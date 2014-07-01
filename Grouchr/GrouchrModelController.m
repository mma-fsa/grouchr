//
//  GrouchrModelController.m
//  Grouchr
//
//  Created by Mike on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GrouchrModelController.h"
#import "GrouchrViewController.h"

static GrouchrModelController* instance = nil; 
static NSString *const facebook_AppID = @"183722865030190";


@implementation GrouchrModelController

@synthesize hasValidToken = _hasValidToken;

@synthesize canPostToFacebook = _canPostToFacebook;
@synthesize canPostToTwitter = _canPostToTwitter;

@synthesize userCredentials = _userCredentials;

@synthesize allowNearbyVenuesUpdate;
@synthesize nearbyVenues = _nearbyVenues;
@synthesize isNearbyVenuesUpdating;

@synthesize isComplaintSubmitting;
@synthesize allowNearbyComplaintsUpdate;
@synthesize nearbyComplaints = _nearbyComplaints;
@synthesize hasFetchedAllNearbyComplaints;
@synthesize isNearbyComplaintsUpdating = _isNearbyComplaintsUpdating;
@synthesize isNearbyComplaintsFetchingNextPage = _isNearbyComplaintsFetchingNextPage;
@synthesize countNearbyComplaintsPages;
@synthesize numberFetchedComplaints;

@synthesize fetchNextPageDelegate;
@synthesize fetchNextPageSelector = _fetchNextPageSelector;

@synthesize didGetSocialNetworks;

@synthesize activeComplaint = _activeComplaint;
@synthesize submitComplaint = _submitComplaint;
@synthesize replyComplaint = _replyComplaint;

@synthesize complaintThreads = _complaintThreads;

@synthesize oAuthTwitter;

#define DEBUG 0
#define GPS_SPOOF 1

- (GrouchrModelController*) init {
    
    if (self = [super init]) {
        
        //init properties
        _complaintThreads = [[NSMutableDictionary alloc] init];
        
        _nearbyVenues = [[NSMutableArray alloc] init];
        _submitComplaint = [[SubmitComplaint alloc] init];
        _replyComplaint = [[SubmitComplaint alloc] init];
        _activeComplaint = nil;
        _userCredentials = [[Credentials alloc] init];
        
        //configuration for GPS
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.distanceFilter = 100;
        lastLocation = nil;
        
        //setup facebook
        _facebook = [[Facebook alloc] initWithAppId:facebook_AppID andDelegate:self];
        
        //allow updates
        self.allowNearbyVenuesUpdate = YES;
        self.allowNearbyComplaintsUpdate = YES;
        
        self.isComplaintSubmitting = NO;
        self.didGetSocialNetworks = NO;
        self.isNearbyComplaintsUpdating = NO;
        self.isNearbyVenuesUpdating = NO;
        self.isNearbyComplaintsFetchingNextPage = NO;
        self.numberFetchedComplaints = 0;
        
        didNetworkError = NO;
        
        //alloc utility to manage our http requests
        dataFetcher = [[DataFetcher alloc] init];
        
        /* Alloc response handlers for http requests */
        
        //system settings handler
        systemSettingsProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector: @selector(hiddenDidGetSystemSettings:)];
        systemSettingsProcessor.APIJsonRequest = NO;
        
        //user management request handlers
        authenticateProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidAuthentication:)];
        loginProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidLogin:)];
        newUserProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidNewUser:)];
        
        //complaint request handlers
        nearbyVenuesProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidFetchNearbyVenues:)];
        nearbyComplaintsProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidFetchNearbyComplaints:)];
        fetchNextPageProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidFetchNextPage:)];
        submitComplaintProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector:@selector(hiddenDidSubmitComplaint:)];
        imageUploadProcessor = [[DataFetcherResponseHandler alloc] initWithDelegate: self withSelector: @selector(hiddenDidImageUpload:)];
        threadFetcherProcessors = [[NSMutableArray alloc] init];
        socialNetworkProcessors = [[NSMutableArray alloc] init];
        
        //setup observers
        [self addObserver: self forKeyPath:@"hasValidToken" options:NSKeyValueChangeSetting context:nil];
        [self addObserver:self forKeyPath:@"oAuthTwitter" options:NSKeyValueChangeSetting context:nil];
    }
    
    return self;    
}

- (void) dealloc {
    [self removeObserver:self forKeyPath:@"hasValidToken"];
    [self removeObserver:self forKeyPath:@"oAuthTwitter"];
}

+ (void) setInstance: (GrouchrModelController*) modelInstance {
    instance = modelInstance;    
}

+ (GrouchrModelController*) getInstance {
    return instance; 
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"hasValidToken" isEqualToString: keyPath] && _hasValidToken == YES) {
        [self startModelUpdating];
        if (self.didGetSocialNetworks == NO) {
            [self startGetSocialNetworks:nil withSelector:nil];
        }
    }
    else if ([@"oAuthTwitter" isEqualToString: keyPath] && oAuthTwitter != nil) {
        [self hiddenDidTwitterAuthentication];
    }
}

- (void) startGetSystemSettings:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startGetSystemSettings called");
    }
    
    systemSettingsDelegate = delegate;
    systemSettingsSelector = selector;
    
    [dataFetcher getSystemSettings: systemSettingsProcessor];
}

- (void) hiddenDidGetSystemSettings:(DataFetcherResponseHandler *)response {
    
    if (DEBUG) {
        NSLog(@"hiddenDidGetSystemSettings: ");
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    else {
        NSString* settingsData = [response responseString];
        NSArray* settings = [settingsData componentsSeparatedByString:@"\n"];
       
        NSString* apiURL = nil;
        NSString* imgURL = nil;
        
        for (NSString *s in settings) {
            
            NSRange charPos = [s rangeOfString: @":"];
            
            if (charPos.location != NSNotFound && charPos.location + 1 < [s length]) {
                NSString *key = [s substringToIndex: charPos.location];
                NSString *val = [[s substringFromIndex: charPos.location + 1] stringByTrimmingCharactersInSet: [NSCharacterSet punctuationCharacterSet]];;
                
                if ([key isEqualToString: @"API"]) {
                    apiURL = val;
                }
                else if ([key isEqualToString: @"API_IMG"]) {
                    imgURL = val;
                }
            }
        }
        
        [DataFetcher setAPIURL:apiURL withPictureUploadURL:imgURL];
    }
    
    if (systemSettingsDelegate != nil && systemSettingsSelector != nil) {
        [systemSettingsDelegate performSelector: systemSettingsSelector];
    }
}

- (void) startFacebookAuthentication:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startFacebookAuthentication called");
    }
    
    facebookAuthenticationDelegate = delegate;
    facebookAuthenticationSelector = selector;
    
    NSArray* facebook_Permissions = [[NSArray alloc] initWithObjects: @"publish_stream", @"offline_access", nil];
    [_facebook authorize: facebook_Permissions];
}

- (void) startTwitterAuthentication:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startTwitterAuthentication called");
    }
    
    twitterAuthenticationDelegate = delegate;
    twitterAuthenticationSelector = selector;
    
    [[GrouchrViewController getInstance] showTwitterLogin];
}

- (void) startAddSocialNetworks:(id)delegate withSelector:(SEL)selector forNetwork:(NSString *)serviceName {
    
    if (DEBUG) {
        NSLog(@"startAddSocialNetworks called: %@\n", serviceName);
    }
    
    DataFetcherResponseHandler* respHandler = [[DataFetcherResponseHandler alloc] 
                                               initWithDelegate:self 
                                               withSelector:@selector(hiddenDidAddSocialNetworks:withServiceName:) 
                                               withObject:serviceName];
    NSObject* payload = nil;
    
    if ([@"FACEBOOK" isEqualToString: serviceName]) {
        NSNumber* expiration = [NSNumber numberWithDouble: [[_facebook expirationDate] timeIntervalSince1970]];
        payload = [GrouchrAPI buildAddSocialNetworkFacebookPayload:[_facebook accessToken] withExpiration: expiration];
    }
    else if ([@"TWITTER" isEqualToString: serviceName]) {        
        payload = [GrouchrAPI buildAddSocialNetworkTwitterPayload: self.oAuthTwitter.oauth_token withSecretToken: self.oAuthTwitter.oauth_token_secret];
    }
    else {
        [NSException raise: NSInvalidArgumentException 
                    format: @"Invalid argument passed to startAddSocialNetworks: %@\n", serviceName];
    }
    
    NSObject* request = [GrouchrAPI buildJsonRequest: @"ADD_SOCIAL_NETWORK" withPayload:payload withCredentials:self.userCredentials];
    NSString* json = [GrouchrAPI jsonize: request];
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"Add social network JSON:\n%@\n", json]);  
    }
    
    [socialNetworkProcessors addObject: respHandler];
    [dataFetcher postDataToAPI: json : respHandler];
}

- (void) startRemoveSocialNetworks:(id)delegate withSelector:(SEL)selector forNetwork:(NSString *)serviceName{
    
    if (DEBUG) {
        NSLog(@"startRemoveSocialNetworks called: %@\n", serviceName);
    }
    
    removeSocialNetworksDelegate = delegate;
    removeSocialNetworksSelector = selector;
 
    DataFetcherResponseHandler* respHandler = [[DataFetcherResponseHandler alloc] 
                                               initWithDelegate:self 
                                               withSelector:@selector(hiddenDidRemoveSocialNetwork:withServiceName:) 
                                               withObject:serviceName];
    NSObject* payload = nil;
    
    if ([@"FACEBOOK" isEqualToString: serviceName]) {
        payload = [GrouchrAPI buildRemoveSocialNetworkFacebookPayload];
    }
    else if ([@"TWITTER" isEqualToString: serviceName]) {
        payload = [GrouchrAPI buildRemoveSocialNetworkTwitterPayload];
    }
    else {
        [NSException raise: NSInvalidArgumentException 
                    format: @"Invalid argument passed to startAddSocialNetworks: %@\n", serviceName];
    }
    
    NSObject* request = [GrouchrAPI buildJsonRequest:@"REMOVE_SOCIAL_NETWORK" withPayload:payload withCredentials:self.userCredentials];
    NSString* json = [GrouchrAPI jsonize: request];
    
    [socialNetworkProcessors addObject: respHandler];
    [dataFetcher postDataToAPI:json :respHandler];
}

- (void) hiddenDidRemoveSocialNetwork: (DataFetcherResponseHandler*) response withServiceName: (NSString*) serviceName {
    
    if (DEBUG) {
        NSLog(@"hiddenDidRemoveSocialNetwork called: %@\n", [response responseString]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    else if ([serviceName isEqualToString: @"FACEBOOK"]){
        self.canPostToFacebook = NO;
    }
    else if ([serviceName isEqualToString: @"TWITTER"]) {
        self.canPostToTwitter = NO;
    }
    else {
        [NSException raise: NSInvalidArgumentException 
                    format: @"Invalid argument passed to hiddenDidRemoveSocialNetwork: %@\n", serviceName];
    }
    
    [socialNetworkProcessors removeObject: response];
    
    if (removeSocialNetworksDelegate != nil && removeSocialNetworksSelector != nil) {
        [removeSocialNetworksDelegate performSelector: removeSocialNetworksSelector];
    }
}

- (void) startGetSocialNetworks:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startGetSocialNetworks called");
    }
    
    getSocialNetworksDelegate = delegate;
    getSocialNetworksSelector = selector;
    
    DataFetcherResponseHandler* respHandler = [[DataFetcherResponseHandler alloc] 
                                               initWithDelegate:self 
                                               withSelector:@selector(hiddenDidGetSocialNetworks:)];
    
    [socialNetworkProcessors addObject: respHandler];
    
    
    NSObject* getSocialNetworkRequest = [GrouchrAPI buildJsonRequest: @"GET_SOCIAL_NETWORKS" withPayload:[[NSDictionary alloc] init] withCredentials: self.userCredentials];
    
    NSString* reqJSON = [GrouchrAPI jsonize: getSocialNetworkRequest];
    
    [dataFetcher postDataToAPI: reqJSON : respHandler];
    
}

- (void) startModelUpdating {
    //begin monitoring GPS changes
    [locationManager startUpdatingLocation];
}

- (void) stopModelUpdating {
    [locationManager stopUpdatingLocation];
}

- (void) startAuthentication:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startAuthentication called");
    }
    
    authenticationDelegate = delegate;
    authenticationSelector = selector;
    
    if (_userCredentials != nil && _userCredentials.username != nil && _userCredentials.token != nil) {
        NSObject* authenticationPayload = [GrouchrAPI buildAuthenticationPayloadForUser: _userCredentials.username withToken: _userCredentials.token];
        NSObject* authenticationRequest = [GrouchrAPI buildJsonRequest: @"AUTHENTICATE"  withPayload:authenticationPayload withCredentials: self.userCredentials];
        NSString* authenticationRequestJSON = [GrouchrAPI jsonize: authenticationRequest];
        [dataFetcher postDataToAPI: authenticationRequestJSON : authenticateProcessor];
    }
    else {
        if (_hasValidToken == YES) {
            [self willChangeValueForKey: @"hasValidToken"];
            _hasValidToken = NO;
            [self didChangeValueForKey: @"hasValidToken"];
        }
        [authenticationDelegate performSelector: authenticationSelector];
    }
}

- (void) startLogin:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startLogin called");
    }
    
    loginDelegate = delegate;
    loginSelector = selector;
    
    if (_userCredentials != nil && _userCredentials.username != nil && _userCredentials.password != nil) {
        NSObject* loginPayload = [GrouchrAPI buildLoginPayloadForUser: _userCredentials.username withPassword: _userCredentials.password];
        NSObject* loginRequest = [GrouchrAPI buildJsonRequest: @"LOGIN"  withPayload: loginPayload withCredentials: self.userCredentials];
        NSString* loginJSON = [GrouchrAPI jsonize: loginRequest];
        [dataFetcher postDataToAPI: loginJSON : loginProcessor];
    }
    else {
        [loginDelegate performSelector: loginSelector withObject: @"BAD_REQUEST"];
    }
}

- (void) startNewUser:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startNewUser called");
    }
    
    newUserDelegate = delegate;
    newUserSelector = selector;
    
    if (_userCredentials != nil && _userCredentials.username != nil && _userCredentials.password != nil) {
        NSObject* newUserPayload = [GrouchrAPI buildNewUserPayloadForUser:_userCredentials.username withPassword:_userCredentials.password];
        NSObject* newUserRequest = [GrouchrAPI buildJsonRequest: @"NEWUSER" withPayload:newUserPayload withCredentials: self.userCredentials];
        NSString* newUserRequestJSON = [GrouchrAPI jsonize: newUserRequest];
        [dataFetcher postDataToAPI: newUserRequestJSON : newUserProcessor];
    }
    else { 
        [newUserDelegate performSelector: newUserSelector withObject: @"BAD_REQUEST"];
    }
}

- (void) startImageUpload:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startImageUpload called");
    }
    
    imageUploadDelegate = delegate;
    imageUploadSelector = selector;
    
    if (lastSubmittedComplaint == nil) {
        NSLog(@"lastSubmittedComplaint is nil!");
        lastSubmittedComplaint.isImageUploaded = YES;
        if (delegate != nil && [delegate respondsToSelector: selector])
            [delegate performSelector: selector];
    }
    
    if (_activeComplaint.image != nil) {
        [dataFetcher postPictureToAPI: lastSubmittedComplaint.imageData withHandle: lastSubmittedComplaint.imageHandle withResponseHandler:imageUploadProcessor];
    }
}

- (NSArray*) complaintThread: (NSInteger) forSubmissionId {
    
    NSArray* thread = [_complaintThreads objectForKey: [[NSNumber numberWithInteger: forSubmissionId] stringValue]];
    if (thread == nil) {
        [self hiddenStartGetThread: forSubmissionId];
    }
    
    return thread;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
     
    lastLocation = newLocation;
    
    if (self.userCredentials.token != nil) {
        [self getNearbyComplaintsForLocation: lastLocation];
    }
}

- (void) getNearbyComplaintsForLocation: (CLLocation*) location {
    
    //fetch nearby locations from our server
    NSNumber* lat = [NSNumber numberWithDouble: location.coordinate.latitude];
    NSNumber* lon = [NSNumber numberWithDouble: location.coordinate.longitude];
    
    if (GPS_SPOOF) {
        lat = [NSNumber numberWithDouble: 44.944191];
        lon = [NSNumber numberWithDouble: -93.242168];
    }
    
    if (self.isNearbyComplaintsUpdating == NO) {
        self.isNearbyComplaintsUpdating = YES;
        _isNearbyComplaintsFetchingNextPage = YES;
        //build nearby complaint request
        self.hasFetchedAllNearbyComplaints = NO;
        self.countNearbyComplaintsPages = [NSNumber numberWithInt: 0];
        NSObject* complaintRequest = [GrouchrAPI buildJsonRequest:@"COMPLAINTS" 
                                                      withPayload:[GrouchrAPI buildNearbyComplaintsPayload: lat : lon : self.countNearbyComplaintsPages.integerValue]
                                                  withCredentials: self.userCredentials];
        NSString* complaintRequestJSON = [GrouchrAPI jsonize: complaintRequest];
        [dataFetcher postDataToAPI: complaintRequestJSON : nearbyComplaintsProcessor];
    }
    
    if (self.isNearbyVenuesUpdating == NO) {
        self.isNearbyVenuesUpdating = YES;
        NSObject* venueRequest = [GrouchrAPI buildJsonRequest: @"NEARBYVENUES" 
                                                  withPayload: [GrouchrAPI buildNearbyVenuesPayload: lat : lon] 
                                              withCredentials: self.userCredentials];
        NSString* requestJSON = [GrouchrAPI jsonize: venueRequest];
        [dataFetcher postDataToAPI: requestJSON : nearbyVenuesProcessor];    
    }
}

     
- (void) startShakeGesture: (id) delegate withSelector: (SEL) selector forObject: (SubmitComplaint*) obj {
    shakeGestureDelegate = delegate;
    shakeGestureSelector = selector;
    shakeGestureObject = obj;
    [[GrouchrShakeGesture sharedInstance] shakeGesture: self];
}

- (void) didShakeGesture {
    NSLog(@"Model didShakeGesture");
    shakeGestureObject.shakepoints = (NSInteger) [[GrouchrShakeGesture sharedInstance] lastScore];
    [shakeGestureDelegate performSelector: shakeGestureSelector];
}

- (void) startSubmitComplaint:(id)delegate withSelector:(SEL)selector {
    
    if (isComplaintSubmitting) {
        return;
    }
    
    isComplaintSubmitting = YES;
    
    if (submitComplaintDelegate != delegate){
        submitComplaintDelegate = delegate;
    }
    if (submitComplaintSelector != selector){
        submitComplaintSelector = selector;
    }
    
    //should implement some checking to see how long ago we got coordinates...
    
    self.activeComplaint.latitude = [NSNumber numberWithDouble: lastLocation.coordinate.latitude];
    self.activeComplaint.longitude = [NSNumber numberWithDouble: lastLocation.coordinate.longitude];
    
    NSObject* submitRequestPayload = [GrouchrAPI buildSubmitComplaintPayload: self.activeComplaint];
    lastSubmittedComplaint = self.activeComplaint;
    NSObject* submitRequest = [GrouchrAPI buildJsonRequest :@"SUBMITCOMPLAINT"
                                                withPayload:submitRequestPayload 
                                            withCredentials: self.userCredentials];
    
    NSString* submitRequestJSON = [GrouchrAPI jsonize: submitRequest];
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"Submitting complaint: %@\n", submitRequestJSON]);
    }
    
    [dataFetcher postDataToAPI: submitRequestJSON : submitComplaintProcessor];
}

- (void) fetchNextPage {

    if (DEBUG) {
        NSLog(@"fetchNextPage called");
    }
    
    if (self.hasFetchedAllNearbyComplaints) {
        if (DEBUG) {
             NSLog(@"fetchNextPage skipped because there are no more results.");
        }
        return;
    }
    if (!self.isNearbyComplaintsUpdating) {
        
        _isNearbyComplaintsUpdating = YES;
        self.isNearbyComplaintsFetchingNextPage = YES;
        
        NSNumber* lat = [NSNumber numberWithDouble: lastLocation.coordinate.latitude];
        NSNumber* lon = [NSNumber numberWithDouble: lastLocation.coordinate.longitude];
        
        if (GPS_SPOOF) {
            lat = [NSNumber numberWithDouble: 44.944191];
            lon = [NSNumber numberWithDouble: -93.242168];
        }
        
        NSObject* nextPageRequest = [GrouchrAPI buildJsonRequest:@"COMPLAINTS" 
                                                withPayload:[GrouchrAPI buildNearbyComplaintsPayload: lat : lon : self.countNearbyComplaintsPages.integerValue + 1] 
                                                withCredentials: self.userCredentials];
        [dataFetcher postDataToAPI: [GrouchrAPI jsonize: nextPageRequest]: fetchNextPageProcessor];
    }
}


- (void) hiddenStartGetThread: (NSInteger) submissionId {
    
    NSDictionary* responseObj = [[NSDictionary alloc] initWithObjectsAndKeys: 
                                 [NSNumber numberWithInteger: submissionId], @"submissionid", nil];
                                                                               
    DataFetcherResponseHandler* processor = [[DataFetcherResponseHandler alloc] 
                                             initWithDelegate:self withSelector:@selector(hiddenDidGetThread:withObject:) withObject: responseObj];
    
    //save this so ARC doesn't deallocate it prematurely (this is what you get when you link to non-ARC compatible code...)
    [threadFetcherProcessors addObject: processor];
    
    NSObject* getThreadPayload = [GrouchrAPI buildGetThreadPayload: submissionId];
    NSObject* getThreadRequest = [GrouchrAPI buildJsonRequest: @"GETTHREAD" withPayload:getThreadPayload withCredentials:self.userCredentials];
    NSString* getThreadJSON = [GrouchrAPI jsonize: getThreadRequest];
    
    [dataFetcher postDataToAPI: getThreadJSON : processor];
}

- (void) hiddenDidGetSocialNetworks: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog(@"hiddenDidGetSocialNetworks called: %@\n", [response responseString]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    
    NSDictionary* socialNetworkInfo = [APIResponseParser getSocialNetworkList: [response payload]];
    
    if ([@"SUCCESS" isEqualToString: [socialNetworkInfo objectForKey: @"TWITTER"]]) {
        self.canPostToTwitter = YES;
    }
    else {
        self.canPostToTwitter = NO;
    }
    
    if ([@"SUCCESS" isEqualToString: [socialNetworkInfo objectForKey: @"FACEBOOK"]]) {
        self.canPostToFacebook = YES;
    }
    else {
        self.canPostToFacebook = NO;
    }
    
    self.didGetSocialNetworks = YES;
    
    if (getSocialNetworksDelegate != nil && getSocialNetworksSelector != nil) {
        [getSocialNetworksDelegate performSelector: getSocialNetworksSelector withObject: socialNetworkInfo];
    }
}

- (void) hiddenDidFetchNextPage: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidFetchNextPage called: %@\n", [response responseString]]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    
 
    
    if ([self hiddenDidRequestAuthenticate: response]) {
        NSArray* nextPage = [APIResponseParser getComplaintList: [response payload]];
        NSNumber* numberAdded = [NSNumber numberWithInt: [nextPage count]];
        if ([nextPage count] > 0) {                                                
            
            NSInteger oldEnd = [self.nearbyComplaints count];
            
            self.numberFetchedComplaints = [nextPage count];
            
            if (self.numberFetchedComplaints < 20) {
                self.hasFetchedAllNearbyComplaints = YES;
            }
            else {
                self.hasFetchedAllNearbyComplaints = NO;
            }
            
            NSMutableArray* nearbyComplaintsWithNextPage = [NSMutableArray arrayWithArray: self.nearbyComplaints];
            [nearbyComplaintsWithNextPage addObjectsFromArray: nextPage];            
            
            for (int i = MAX(0, oldEnd - 1); i<[nearbyComplaintsWithNextPage count]; i++) {
                Complaint* c = [nearbyComplaintsWithNextPage objectAtIndex: i];            
                NSString* subId = [NSString stringWithFormat: @"%d", c.submissionid];
                if ([complaintListIndexForSubmissionId objectForKey: subId] == nil){
                    NSString* idx = [NSString stringWithFormat: @"%d", i];
                    [complaintListIndexForSubmissionId setObject: idx forKey: subId];
                }            
            }
                                           
            self.nearbyComplaints = nearbyComplaintsWithNextPage;                        
            self.countNearbyComplaintsPages = [NSNumber numberWithInt: self.countNearbyComplaintsPages.integerValue + 1];            
        }
        else {
            //simulate the event, although we don't really change it
            [self willChangeValueForKey: @"countNearbyComplaintsPages"];
            self.hasFetchedAllNearbyComplaints = YES;
            [self didChangeValueForKey: @"countNearbyComplaintsPages"];
        }
    
        lastFetchNextPageTime = [NSDate date];
        
        if (self.fetchNextPageDelegate != nil && self.fetchNextPageSelector != nil) {
            [self.fetchNextPageDelegate performSelector: _fetchNextPageSelector withObject: numberAdded];
        }    
    }
 
    _isNearbyComplaintsUpdating = NO;
    self.isNearbyComplaintsFetchingNextPage = NO;
}

- (void) hiddenDidAddSocialNetworks: (DataFetcherResponseHandler*) response withServiceName: (NSString*) serviceName {

    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidAddSocialNetworks called: %@\n", [response responseString]]);
    }
    
    BOOL success = YES;
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
        success = NO;
    }
    
    if ([@"FACEBOOK" isEqualToString: serviceName]) {
        self.canPostToFacebook = success;
    }
    else if ([@"TWITTER" isEqualToString: serviceName]) {
        self.canPostToTwitter = success;
    }
    
    [socialNetworkProcessors removeObject: response];
}

- (void) startLogout:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startLogout called");
    }
    
    if (self.hasValidToken) {
        [self willChangeValueForKey: @"hasValidToken"];
        _hasValidToken = NO;
        [self didChangeValueForKey: @"hasValidToken"];
        self.userCredentials = [[Credentials alloc] init];
    }
    
    if (delegate != nil && selector != nil) {
        [delegate performSelector: selector];
    }
}

- (void) startFacebookLogout:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startFacebookLogout called");
    }
    
    facebookLogoutDelegate = delegate;
    facebookLogoutSelector = selector;
    
    [self startRemoveSocialNetworks:self withSelector:@selector(hiddenDidFacebookLogout) forNetwork:@"FACEBOOK"];
}

- (void) hiddenDidFacebookLogout {
    
    if (DEBUG) {
        NSLog(@"hiddenDidFacebookLogout called");
    }
    
    if (facebookLogoutDelegate != nil && facebookLogoutSelector != nil) {
        [facebookLogoutDelegate performSelector: facebookLogoutSelector];
    }
}

- (void) startTwitterLogout:(id)delegate withSelector:(SEL)selector {
    
    if (DEBUG) {
        NSLog(@"startTwitterLogout called");
    }
    
    twitterLogoutDelegate = delegate;
    twitterLogoutSelector = selector;
    
    [self startRemoveSocialNetworks:self withSelector:@selector(hiddenDidTwitterLogout) forNetwork:@"TWITTER"];
}

- (void) hiddenDidTwitterLogout {
    
    if (DEBUG) {
        NSLog(@"startTwitterLogout called");
    }
 
    if (twitterLogoutDelegate != nil && twitterLogoutSelector != nil) {
        [twitterLogoutDelegate performSelector: twitterLogoutSelector];
    }
}

/* 
    Facebook Stuff
 
*/

- (Facebook*) facebook {
    return _facebook;
}

- (void) fbDidLogin {
    
    if (DEBUG) {
        NSLog(@"fbDidLogin\n");
    }
    
    //todo: set social network.
    NSString* token = [_facebook accessToken];
 
    BOOL success = (token != nil && [token length] > 0);
    
    if (success && !self.canPostToFacebook) {
        self.canPostToFacebook = YES; 
        [self startAddSocialNetworks: self withSelector:@selector(hiddenDidAddSocialNetworks:withServiceName:) forNetwork: @"FACEBOOK"];
    }
    
    if (facebookAuthenticationDelegate != nil && facebookAuthenticationSelector != nil) {
        [facebookAuthenticationDelegate performSelector: facebookAuthenticationSelector withObject: [NSNumber numberWithBool: success]];
    }
}

/*
    
    COMPLAINT AND VENUE 

 */

- (void) hiddenDidImageUpload: (DataFetcherResponseHandler*) response {

    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidImageUpload called: %@", [response responseString]]);
    }
    
    lastSubmittedComplaint.isImageUploaded = YES;
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
            
    response.error = nil;
    [self performSelector: @selector(hiddenDidSubmitComplaint:) withObject: response];
}

- (void) hiddenDidSubmitComplaint: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidFetchNearbyVenues called: %@\n", [response responseString]]);
    }
    
    if (response.error != nil) {
        self.isComplaintSubmitting = NO;
        [self hiddenDidRequestError: response];
    }
    else if ([self hiddenDidRequestAuthenticate: response] == NO && _hasValidToken == YES) {
        self.isComplaintSubmitting = NO;
        [self willChangeValueForKey: @"hasValidToken"];
        _hasValidToken = NO;
        [self didChangeValueForKey: @"hasValidToken"];
    }
    else if (lastSubmittedComplaint.image != nil && lastSubmittedComplaint.isImageUploaded == NO) {    
        
        lastSubmittedComplaint.submissionId = [[response payload] objectForKey: @"SUBMISSIONID"];
        lastSubmittedComplaint.imageHandle = [response.payload objectForKey: @"IMAGEHANDLE"];
        
        [self startImageUpload:self withSelector:@selector(hiddenDidImageUpload:)];        
        return;
    }
    else {
        self.isComplaintSubmitting = NO;
                
        NSString* submissionIdString = (lastSubmittedComplaint.submissionId != nil) ? 
        lastSubmittedComplaint.submissionId : [[response payload] objectForKey: @"SUBMISSIONID"];
        
        NSInteger submissionId = [submissionIdString intValue];
        SubmitComplaint* s = lastSubmittedComplaint;
        Complaint* c = [[Complaint alloc] init];
        
        c.username = self.userCredentials.username;   
        c.submissionid = submissionId;
        c.message = s.message;
        c.venuename = s.venue.name;
        c.shakepoints = s.shakepoints;
        c.childcount = 0;
        c.childshakepoints = 0;                
        c.imageurl_small = nil;
        c.imageurl_orig = nil;
        c.imageurl_medium = nil;
        c.imageurl_large = nil;
        
        //update model to reflect a new thread
        if (lastSubmittedComplaint.parentThreadId == nil) {                                    
            c.hasImage = lastSubmittedComplaint.isImageUploaded;            
            [self willChangeValueForKey: @"nearbyComplaints"];
            [self.nearbyComplaints insertObject: c atIndex: 0];
            [self didChangeValueForKey: @"nearbyComplaints"];
            
            // do not update complaint threads, we want to actually fetch this
            // so we can get images and stuff
            
        }
        //update model to reflect a new reply
        else if ([self.complaintThreads objectForKey: [s.parentThreadId stringValue]] != nil){            
            
            NSString* parentIdx = [complaintListIndexForSubmissionId objectForKey: [lastSubmittedComplaint.parentThreadId stringValue]];
            Complaint* parent = [self.nearbyComplaints objectAtIndex: [parentIdx integerValue]];
            
            //update the reply count
            if (parent != nil) {
                [self willChangeValueForKey: @"nearbyComplaints"];
                parent.childcount = parent.childcount + 1;
                [self didChangeValueForKey: @"nearbyComplaints"];            
            }
                
            //update the thread
            NSMutableArray* arr = [self.complaintThreads objectForKey: [s.parentThreadId stringValue]];
            [self willChangeValueForKey: @"complaintThreads"];
            [arr addObject: c];
            [self didChangeValueForKey: @"complaintThreads"];
        }                
    }
    
    if (submitComplaintDelegate != nil && submitComplaintSelector != nil) {                
        [submitComplaintDelegate performSelector: submitComplaintSelector withObject: @"SUCCESS"];
    }        
}

- (void) hiddenDidFetchNearbyVenues: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidFetchNearbyVenues called: %@\n", [response responseString]]);
    }
        
    self.isNearbyVenuesUpdating = NO;
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    else if ([self hiddenDidRequestAuthenticate: response] == NO) {
        return;
    }
    else {    
        [_nearbyVenues willChangeValueForKey: @"nearbyVenues"];
        _nearbyVenues = [APIResponseParser getVenueList: [response payload]];    
        [_nearbyVenues didChangeValueForKey: @"nearbyVenues"];
    }
}

- (void) hiddenDidFetchNearbyComplaints: (DataFetcherResponseHandler*) response {
    
    if (DEBUG){ 
        NSLog([NSString stringWithFormat: @"hiddenDidFetchNearbyComplaints called: %@\n", [response responseString]]);
    }
    
    self.isNearbyComplaintsUpdating = NO;
    _isNearbyComplaintsFetchingNextPage = NO; 
    
    if (response.error != nil) {           
        [self hiddenDidRequestError: response];
        return;
    }
    
    if ([self hiddenDidRequestAuthenticate: response] == NO) {
        //try again in 15 seconds
        
        return;
    }

    if (allowNearbyComplaintsUpdate) {
        
        complaintListIndexForSubmissionId = [[NSMutableDictionary alloc] init];
        
        //maintain an index of thread submissionIds
        NSMutableArray* complaintList = [APIResponseParser getComplaintList: [response payload]];
        for (int i=0; i<[complaintList count]; i++) {
            Complaint* c = [complaintList objectAtIndex: i];            
            NSString* subId = [NSString stringWithFormat: @"%d", c.submissionid];
            if ([complaintListIndexForSubmissionId objectForKey: subId] == nil){
                NSString* idx = [NSString stringWithFormat: @"%d", i];
                [complaintListIndexForSubmissionId setObject: idx forKey: subId];
            }
        }        
        
        if ([complaintList count] < 20) {
            self.hasFetchedAllNearbyComplaints = YES;
        }
        else {
            self.hasFetchedAllNearbyComplaints = NO;
        }
        
        //inform observers the value is about to change
        [self willChangeValueForKey: @"nearbyComplaints"];
        _nearbyComplaints = complaintList;
        //broadcast the change to subscribers via KVO
        [self didChangeValueForKey: @"nearbyComplaints"];   
        
    }
    else {
        //TODO: register observer to update nearby complaints once it is allowed to do so
    }
    
}

- (void) hiddenDidTwitterAuthentication {
    
    if (DEBUG) {
        NSLog(@"hiddenDidTwitterAuthentication called");
    }
    
    BOOL success = (self.oAuthTwitter != nil) && (self.oAuthTwitter.oauth_token != nil) && ([self.oAuthTwitter.oauth_token length] > 0);
    
    if (success && !self.canPostToTwitter) {
        self.canPostToTwitter = YES; 
        [self startAddSocialNetworks: self withSelector:@selector(hiddenDidAddSocialNetworks:) forNetwork: @"TWITTER"];
    }
    else {
        NSLog(@"hiddenDidTwitterAuthentication failed!");
    }
    
    if (twitterAuthenticationDelegate != nil && twitterAuthenticationSelector != nil) {
        [twitterAuthenticationDelegate performSelector: twitterAuthenticationSelector];
    }
}

- (void) hiddenDidGetThread: (DataFetcherResponseHandler*) response withObject: (NSObject*) theObject {
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidGetThread called w/ response: \n %@",
               [response responseString]]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
        [threadFetcherProcessors removeObject: response];
        return;
    }
    
    if (theObject != nil) {
        NSDictionary* params = (NSDictionary*)theObject;
        NSArray* thread = [APIResponseParser getThreadList: [response payload]];
        NSNumber* submissionid = [params objectForKey: @"submissionid"];
        
        [self willChangeValueForKey: @"complaintThreads"];
        [self.complaintThreads setValue:thread forKey: [submissionid stringValue]];
        [self didChangeValueForKey: @"complaintThreads"];
    }
    
    //remove the request from the processing array
    [threadFetcherProcessors removeObject: response];
}

/*
 
    USER MANAGEMENT STUFF
 
 */

// checks if server rejected request due to bad token, for non-usermanagement requests
- (BOOL) hiddenDidRequestAuthenticate: (DataFetcherResponseHandler*) response {
    
    if ([@"SUCCESS" isEqualToString: response.statusMessage]) {
        return YES;
    }
    
    return NO;
}

// checks if the server responded that token was valid
- (void) hiddenDidAuthentication: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidAuthentication called w/ response: \n %@",
               [response responseString]]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    
    BOOL isAuthenticated = [@"SUCCESS" isEqualToString: response.statusMessage];
    if ( _hasValidToken != isAuthenticated) {
        [self willChangeValueForKey: @"hasValidToken"];
        _hasValidToken = isAuthenticated;
        [self didChangeValueForKey: @"hasValidToken"];   
    }
    
    if (authenticationDelegate != nil && authenticationSelector != nil) {
        [authenticationDelegate performSelector: authenticationSelector];
    }
    
    if (isAuthenticated && lastLocation != nil) {
        [self getNearbyComplaintsForLocation: lastLocation];
    }
}

- (void) hiddenDidLogin: (DataFetcherResponseHandler*) response {
 
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidLogin called w/ response: \n %@",
               [response responseString]]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    
    NSString* errorCode = nil;
    BOOL didLoginSuccessfully = [@"SUCCESS" isEqualToString: response.statusMessage];
    if (didLoginSuccessfully) {        
        _userCredentials = [APIResponseParser getCredentials: [response payload]];
        [self willChangeValueForKey: @"hasValidToken"];
        _hasValidToken = YES;
        [self didChangeValueForKey: @"hasValidToken"];
    }
    else if ([@"FAILURE" isEqualToString: response.statusMessage] ) {
        errorCode = [[response payload] objectForKey: @"FAILURE_CODE"];
    }
    else {
        errorCode = @"UNKNOWN";
    }
    
    if (loginDelegate != nil && loginSelector != nil) {
        [loginDelegate performSelector: loginSelector withObject: errorCode ];
    }
}

- (void) hiddenDidNewUser: (DataFetcherResponseHandler*) response {
 
    if (DEBUG) {
        NSLog([NSString stringWithFormat: @"hiddenDidLogin called w/ response: \n %@",
               [response responseString]]);
    }
    
    if (response.error != nil) {
        [self hiddenDidRequestError: response];
    }
    
    NSString* errorCode = nil;
    if ([@"FAILURE" isEqualToString: response.statusMessage] ) {
        errorCode = [[response payload] objectForKey: @"FAILURE_CODE"];
    }
    else {
        errorCode = @"UNKNOWN";
    }
    
    if (newUserDelegate != nil && newUserSelector != nil) {
        [newUserDelegate performSelector: newUserSelector withObject: errorCode];
    }
}

/*
    Facebook Delegate 
*/

/*
  
    ERROR HANDLER 
 
*/

- (void) hiddenDidRequestError: (DataFetcherResponseHandler*) response {
    
    if (DEBUG) {
        NSLog(@"hiddenDidRequestError\n");
    }
    
    
    //only kick-off this notification once in the lifetime of this model object    
    if (didNetworkError == NO) {
        didNetworkError = YES;
        [self stopModelUpdating];
        [[NSNotificationCenter defaultCenter] 
         postNotificationName:@"NetworkError" 
         object:nil];
    }
}



@end
