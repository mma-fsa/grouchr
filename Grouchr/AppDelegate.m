//
//  AppDelegate.m
//  nostoryboard2
//
//  Created by Joel Drotos on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"

#define USE_TESTING_ENV 0

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    hasConnection = YES; //this will change if either of the reachability checkers fail
    
    //begin monitoring internet disconnection / backend unavailability
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self handleReachabilityStatus: internetReach];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenDidNetworkError) 
                                                 name: @"NetworkError"
                                               object:nil];
    //start the app
    [self initApp];

    return YES;
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    [model startModelUpdating];
    viewController.canShowNetworkError = YES;
}

- (void) applicationWillResignActive:(UIApplication *)application {
    viewController.canShowNetworkError = NO;
    [DataFetcherResponseHandler invalidateRequests];
    [model stopModelUpdating];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [model removeObserver:self forKeyPath: @"hasValidToken"];
}

- (void) hiddenDidNetworkError {
    NSLog(@"Network error occurred");
    [self restartApp];
}

- (void) reachabilityChanged:(NSNotification *)note {
    [self handleReachabilityStatus: note.object];
}

- (void) handleReachabilityStatus: (Reachability*) curReach {
    
    NetworkStatus netStatus = curReach.currentReachabilityStatus;
    
    if (netStatus == NotReachable) {
        NSString* message = @"";
        if (curReach == internetReach) {
            message = @"An internet data connection is required to use this application, please press OK once a connection is available to try again.";
        }
        
        hasConnection = NO;
        
        UIAlertView* netErr = [[UIAlertView alloc] initWithTitle: @"Connection error" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [netErr show];
    }
    else if (netStatus != NotReachable) {
        hasConnection = YES;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self handleReachabilityStatus: internetReach];
    [self restartApp];
}

- (void) initApp {

    if (hasConnection == NO) {
        return;
    }
    
    //check if we have stored credentials to retrieve
    userData = [[GrouchrUserData alloc] init];
    
    //create the lazy-man's singleton
    model = [[GrouchrModelController alloc] init];
    [GrouchrModelController setInstance: model];
    
    [model addObserver:self forKeyPath:@"hasValidToken" options:NSKeyValueChangeSetting context:nil];
    
    //setup the view
    [self initGrouchrViewController];

    //fetch the system settings
    viewController.skipLoginOnce = YES;
    [viewController showLoadingOverlay: @"Fetching settings..."];
    [model startGetSystemSettings:self withSelector:@selector(didGetSystemSettings)];
    
}

- (void) killApp {
    [viewController hideLoadingOverlay];
    [[viewController alert] dismissWithClickedButtonIndex:0 animated:NO];
    [model removeObserver:self forKeyPath: @"hasValidToken"];
    
    model = nil;
    viewController = nil;
    self.window.rootViewController = nil;
}

- (void) restartApp {
    [self killApp];
    [self initApp];
}

- (void) didAuthenticateToken {
    NSLog(@"didAuthenticateToken\n");
    viewController.skipLoginOnce = NO;
    [viewController hideLoadingOverlay];
    
    if (model.hasValidToken == NO) {
        [viewController showUsermanagement];
    }
}

- (void) didGetSystemSettings {
    NSLog(@"didGetSystemSettings");
    
    if (USE_TESTING_ENV) {
        [DataFetcher setAPIURL:@"http://tomcat.jdrotos.dyndns.org:8080/GrouchrServer/API" withPictureUploadURL:@"http://tomcat.jdrotos.dyndns.org:8080/GrouchrServer/ImageUpload"];
    }
    
    if (userData.storedCredentials != nil) {
        [viewController showLoadingOverlay: @"Checking token..."];
        model.userCredentials = userData.storedCredentials;
        [model startAuthentication:self withSelector:@selector(didAuthenticateToken)];
    }
    else {
        [viewController showUsermanagement];
        [viewController hideLoadingOverlay];
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if (model != nil && [model facebook] != nil) {
        Facebook* fb = [model facebook];
        return [fb handleOpenURL: url];
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString* scheme = [url scheme];
    
    if (model != nil) {
        if ([@"fb183722865030190" isEqualToString: scheme]) {
            return [self handleFBAuth: url];
        }
        else if ([@"x-oauthflow-grouchr-twitter" isEqualToString: scheme]) {
            return [self handleTwitterAuth: url];
        }        
    }
    
    return NO;
}

- (BOOL) handleFBAuth: (NSURL*) url {
    
    NSLog(@"handleFBAuth called"); 
    
    BOOL success = NO;
    Facebook* facebook = [model facebook];
    if (facebook != nil) {
        //this calls the facebook delegate on the model if successful
        success =  [facebook handleOpenURL: url];
    } 
    NSLog(@"NIL model in handleFBAuth");
    
    
    if (!success) {
        //todo: alert 
    }
    //else: facebook object will fbDidLogin
    
    return success;
}

- (BOOL) handleTwitterAuth:(NSURL *)url {
    
    NSLog(@"handleTwitterAuth called"); 
    
    
    TwitterOAuthUtility* util = viewController.twitterUtility;
    
    // naively parse url
    NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
    for (NSString *chunk in requestParameterChunks) {
        NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
        if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
            [util.loginPopup authorizeOAuthVerifier: [keyVal objectAtIndex:1]];
        }
    }
    
    return YES;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([@"hasValidToken" isEqualToString: keyPath]) {
        if (model.hasValidToken) {
            userData.storedCredentials = model.userCredentials;
        }
        else {
            userData.storedCredentials = nil;
        }
    }
}

- (void) initGrouchrViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    viewController = [[GrouchrViewController alloc] init];
    [GrouchrViewController setInstance: viewController];
    CGRect b = self.window.bounds;
    b.size.height = b.size.height - 50;
    [viewController.view setBounds: b];
    self.window.rootViewController = viewController; 
    [self.window makeKeyAndVisible];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [viewController hideTwitterLogin];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
