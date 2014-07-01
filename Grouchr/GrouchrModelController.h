//
//  GrouchrModelController.h
//  Grouchr
//
//  Created by Mike on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "SubmitComplaint.h"
#import "Complaint.h"
#import "Credentials.h"

#import "TwitterLoginPopup.h"
#import "GrouchrAPI.h"
#import "APIResponseDelegate.h"
#import "DataFetcher.h"
#import "DataFetcherResponseHandler.h"
#import "GrouchrModelDelegate.h"
#import "GrouchrShakeGesture.h"
#import "FBConnect.h"

@interface GrouchrModelController : NSObject<CLLocationManagerDelegate, UIAccelerometerDelegate, APIResponseDelegate, FBSessionDelegate> {
    
    //shake gesture delegate
    id shakeGestureDelegate;
    SEL shakeGestureSelector;
    SubmitComplaint* shakeGestureObject;
    
    //submit complaint delegate;
    id submitComplaintDelegate;
    SEL submitComplaintSelector;
    
    //authentication delegate
    id authenticationDelegate;
    SEL authenticationSelector;
    
    //login deleate
    id loginDelegate;
    SEL loginSelector;
    
    //create user delegate
    id newUserDelegate;
    SEL newUserSelector;
    
    //image upload delegate
    id imageUploadDelegate;
    SEL imageUploadSelector;
    
    //get social networks delegate
    id getSocialNetworksDelegate;
    SEL getSocialNetworksSelector;
    
    //save social networks delegate
    id saveSocialNetworksDelegate;
    SEL saveSocialNetworksSelector;
    
    //remove social networks delegate
    id removeSocialNetworksDelegate;
    SEL removeSocialNetworksSelector;
    
    //facebook delegate
    id facebookAuthenticationDelegate;
    SEL facebookAuthenticationSelector;
    id facebookLogoutDelegate;
    SEL facebookLogoutSelector;
    
    //twitter delegate
    id twitterAuthenticationDelegate;
    SEL twitterAuthenticationSelector;
    id twitterLogoutDelegate;
    SEL twitterLogoutSelector;
    
    //system settings delegate
    id systemSettingsDelegate;
    SEL systemSettingsSelector;
    
    //location stuff for iPhone GPS
    CLLocationManager* locationManager;
    CLLocation* lastLocation;

    //object for sending API requests
    DataFetcher* dataFetcher;
    
    //throttling stuff
    NSDate* lastFetchNextPageTime;
    
    /* Objects for processing API requests */
    
    // Complaints stuff
    DataFetcherResponseHandler* nearbyVenuesProcessor;
    DataFetcherResponseHandler* nearbyComplaintsProcessor;
    DataFetcherResponseHandler* fetchNextPageProcessor;
    DataFetcherResponseHandler* submitComplaintProcessor;
    DataFetcherResponseHandler* imageUploadProcessor;
    NSMutableArray* threadFetcherProcessors;
    NSMutableArray* socialNetworkProcessors;
    SubmitComplaint* lastSubmittedComplaint;
    
    // User management stuff
    DataFetcherResponseHandler* authenticateProcessor;
    DataFetcherResponseHandler* loginProcessor;
    DataFetcherResponseHandler* newUserProcessor;
    
    // System settings
    DataFetcherResponseHandler* systemSettingsProcessor;
    
    //Facebook object
    Facebook* _facebook;
    
    NSMutableDictionary* complaintListIndexForSubmissionId;
    
    BOOL didNetworkError;
}

+ (void) setInstance: (GrouchrModelController*) instance;
+ (GrouchrModelController*) getInstance;

- (void) startGetSystemSettings: (id) delegate withSelector: (SEL) selector;
- (void) hiddenDidGetSystemSettings: (DataFetcherResponseHandler*) response;

- (void) startModelUpdating;
- (void) stopModelUpdating;

- (void) startShakeGesture: (id) delegate withSelector: (SEL) selector forObject: (SubmitComplaint*) obj;
- (void) didShakeGesture;

- (void) startSubmitComplaint: (id) delegate withSelector: (SEL) selector;
//- (void) didSubmitComplaint;

- (void) getNearbyComplaintsForLocation: (CLLocation*) location;
- (void) fetchNextPage;
- (BOOL) hiddenDidRequestAuthenticate: (DataFetcherResponseHandler*) response;

- (void) hiddenStartGetThread: (NSInteger) threadIndex; 

- (void) hiddenDidTwitterAuthentication;

// general request error handler
- (void) hiddenDidRequestError: (DataFetcherResponseHandler*) response;

//User management
- (void) startAuthentication: (id) delegate withSelector: (SEL) selector;
- (void) startLogin: (id) delegate withSelector: (SEL) selector;
- (void) startNewUser: (id) delegate withSelector: (SEL) selector;
- (void) startImageUpload: (id) delegate withSelector: (SEL) selector; 

- (void) startLogout: (id) delegate withSelector: (SEL) selector;
- (void) startFacebookLogout: (id) delegate withSelector: (SEL) selector;
- (void) startTwitterLogout: (id) delegate withSelector: (SEL) selector;

//Social networking methods (external)
- (void) startFacebookAuthentication: (id) delegate withSelector: (SEL) selector;
- (void) startTwitterAuthentication: (id) delegate withSelector: (SEL) selector;

//Social networking methods (internal)
- (void) startGetSocialNetworks: (id) delegate withSelector: (SEL) selector;
- (void) startAddSocialNetworks: (id) delegate withSelector: (SEL) selector forNetwork: (NSString*) serviceName;
- (void) startRemoveSocialNetworks: (id) delegate withSelector: (SEL) selector forNetwork: (NSString*) serviceName;

@property (nonatomic, strong) id fetchNextPageDelegate;
@property (nonatomic) SEL fetchNextPageSelector;

//we'll use this to monitor token failures on the UI
@property (nonatomic,readonly) BOOL hasValidToken;

//social networking properies
- (Facebook*) facebook;
@property (nonatomic) BOOL canPostToFacebook;
@property (nonatomic) BOOL canPostToTwitter;
@property (nonatomic, strong) OAuthTwitter* oAuthTwitter;
@property (nonatomic) BOOL didGetSocialNetworks;

//store the user credentials used to login/authenticate
@property (nonatomic, strong) Credentials* userCredentials;

@property (nonatomic) BOOL allowNearbyVenuesUpdate;
@property (nonatomic) BOOL isNearbyVenuesUpdating;
@property (nonatomic, strong, readwrite) NSMutableArray* nearbyVenues;

@property (nonatomic) BOOL isComplaintSubmitting;
@property (nonatomic) BOOL allowNearbyComplaintsUpdate; 
@property (nonatomic) BOOL isNearbyComplaintsUpdating;
@property (nonatomic) BOOL isNearbyComplaintsFetchingNextPage;
@property (nonatomic) BOOL hasFetchedAllNearbyComplaints;
@property (nonatomic) NSInteger numberFetchedComplaints;

@property (nonatomic, strong) NSNumber* countNearbyComplaintsPages;
@property (nonatomic, strong) NSMutableArray* nearbyComplaints;

- (NSArray*) complaintThread: (NSInteger) forSubmissionId;

@property (nonatomic, strong) NSMutableDictionary* complaintThreads;

//an array of arrays, we cache the threads so that complaintThreads[(NSString*)submissionId] = (Thread of replies as NSArray)
@property (nonatomic, strong, readwrite) SubmitComplaint* activeComplaint;

@property (nonatomic, strong, readwrite) SubmitComplaint* submitComplaint;
@property (nonatomic, strong, readwrite) SubmitComplaint* replyComplaint;

@end
