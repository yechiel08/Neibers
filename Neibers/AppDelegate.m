//
//  AppDelegate.m
//  Neibers
//
//  Created by Yechiel Amar on 14/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"
#import "MapViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "SenderBrain.h"
#import "StartViewController.h"

#include <sys/xattr.h>

NSString *const FBSessionStateChangedNotification = @"com.Yechiel.Neibers:FBSessionStateChangedNotification";

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize statusUser;
@synthesize userProfile, userPath;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        NSLog(@"In fallback handler");
                    }];
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    // handling statusBar (iOS7)
    self.window.frame = [UIScreen mainScreen].applicationFrame;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupColors];

    userProfile = [[NSArray alloc]init];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (launchOptions != nil)
	{
		NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
		}
	}
    
    [self turnOffiCloudBackupForUrls];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 7)
    {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    else
    {
        // handling statusBar (iOS7)
        application.statusBarStyle = UIStatusBarStyleLightContent;
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        self.window.clipsToBounds = YES;
        
        // handling screen rotations for statusBar (iOS7)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    
    //checking for exist of the user data as NEW_USER_FILE_NAME
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"StatusSign"]isEqualToString:@"SignIn"]){
                
//        [SenderBrain loudUserProfile];
//        [SenderBrain getUserLastActivity];
        
        [NSThread detachNewThreadSelector:@selector(runTimerInBackground) toTarget:self withObject:nil];
        //        [self sendLatLon];
        //        [self performSelectorInBackground:@selector(sendLatLon) withObject:nil];
        
        //        if ([[userProfile valueForKey:@"UserImage"] isEqualToString:@""]) {
        //
        //        }else{
        //            NSData *dataImage = [self repalseUrlStringToData:[userProfile valueForKey:@"UserImage"]];
        //            [userPath setObject:dataImage forKey:KEY_USER_IMAGE];
        //            [userPath writeToFile:path atomically:YES];
        //        }
        MapViewController *frontViewController = [[MapViewController alloc] init];
        RearViewController *rearViewController = [[RearViewController alloc] init];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
        
        RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
        self.viewController = revealController;
        
        self.window.rootViewController = self.viewController;
    }
    else {
        StartViewController *masterViewController = [[StartViewController alloc] initWithNibName:@"StartViewController" bundle:nil];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
        [masterViewController.navigationController setNavigationBarHidden:TRUE];
//        [UIApplication sharedApplication].statusBarHidden=TRUE;
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIBackgroundTaskIdentifier bgTask = 0;
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [FBSession.activeSession close];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        NSLog(@"Error: Facebook - %@",error.localizedDescription);
        //        UIAlertView *alertView = [[UIAlertView alloc]
        //                                  initWithTitle:@"Error"
        //                                  message:error.localizedDescription
        //                                  delegate:nil
        //                                  cancelButtonTitle:@"OK"
        //                                  otherButtonTitles:nil];
        //        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"basic_info", @"email", @"user_photos",
                            nil];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (NSString *)getNibNameWithName:(NSString *)name
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)
            return name;
        if(result.height == 568)
            return [NSString stringWithFormat:@"%@_iPhone5",name];
    }
    else
        return [NSString stringWithFormat:@"%@_iPad",name];
    return nil;
}

#pragma mark -
#pragma mark push notificaiton

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
	NSLog(@"Received notification: %@", userInfo);
    //    [Utils showAlert:userInfo[@"aps"][@"alert"]];
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
        NSString *message = nil;
        
        NSDictionary *aps = [NSDictionary dictionaryWithDictionary:(NSDictionary *) [userInfo objectForKey:key] ];
        for (id key1 in aps){
            NSLog(@"key1: %@", key1);
            id alert = [aps objectForKey:key1];
            if ([alert isKindOfClass:[NSDictionary class]]) {
                message = [alert objectForKey:@"body"];
                NSLog(@"body: %@, value: %@", key1, message);
                message = [alert objectForKey:@"loc-args"];
                NSLog(@"loc-args: %@, value: %@", key1, message);
                NSArray *args = (NSArray *) [alert objectForKey:@"loc-args"] ;
                for (id key2 in args){
                    NSLog(@"key2: %@, value: ", key2);
                }
                message = [alert objectForKey:@"action-loc-key"];
                NSLog(@"action-loc-key: %@, value: %@", key1, message);
                
            }
            else if ([alert isKindOfClass:[NSArray class]]) {
                for (id key2 in key1){
                    NSLog(@"key2: %@, value: %@", key2, [key1 objectForKey:key2]);
                }
            }
            else if([key1 isKindOfClass:[NSString class]]) {
                message = [aps objectForKey:key1];
                NSLog(@"key1: %@, value: %@", key1, message);
            }
            
        }
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[[[deviceToken description]
                          stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"%@", dToken);
    [[NSUserDefaults standardUserDefaults] setObject:dToken forKey:@"DeviceToken"];
    
    _deviceTokenSingture = dToken;
    //    [Utils showAlert:[NSString stringWithFormat:@"%@",deviceToken]];
    [SenderBrain setPushNotificationEnable];
    if ([SenderBrain isItFirstTimeApplicationRunInTheDevice]){
        [SenderBrain addToken:_deviceTokenSingture];
        
    }
    else {
        [SenderBrain addToken:_deviceTokenSingture];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError:%@", [error localizedDescription]);
    
    NSString* str= @"";
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"DeviceToken"];

    NSData* deviceToken=[str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *tokenData = [NSString stringWithFormat:@"%@",deviceToken];
    tokenData = [tokenData stringByReplacingOccurrencesOfString:@" " withString:@""];
    tokenData = [tokenData stringByReplacingOccurrencesOfString:@"<" withString:@""];
    tokenData = [tokenData stringByReplacingOccurrencesOfString:@">" withString:@""];
    _deviceTokenSingture = tokenData;
    
    if (1 == 2) {
        NSLog(@"set push notificaiton enable in simulator with return");
        [SenderBrain setPushNotificationEnable];
        if ([SenderBrain isItFirstTimeApplicationRunInTheDevice]){
            [SenderBrain addToken:_deviceTokenSingture];
            
        }
        else {
            [SenderBrain addToken:_deviceTokenSingture];
        }
    }
    [SenderBrain setNoPushNotificationEnable];
}

- (BOOL)setupLocationMgr
{
    CLLocationManager *locationMgr = [[CLLocationManager alloc] init];
    locationMgr.purpose = @"";
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
}

- (void)turnOffiCloudBackupForUrls
{
    NSString *documentsDataPath = [[NSString alloc] initWithString:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    [self addSkipBackupAttributeToItemAtURL:[NSURL URLWithString:documentsDataPath]];//All Document folder will be stoped from backing up to iCloud//
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

-(NSData *) repalseUrlStringToData: (NSString *)urlString{
    NSURL *Imageurl = [NSURL URLWithString:urlString];
    NSData *data =  [NSData dataWithContentsOfURL:Imageurl];
    return data;
}

-(UIImage *) repalseDateToImage: (NSData *)dataImage{
    UIImage *image = [[UIImage alloc] initWithData:dataImage];
    return image;
}

/**
 
 * Returns the current location of the device, using iphone locator API
 
 */

-(NSString *)getCurrentLocationOfDevice

{
    
    CLLocationCoordinate2D location;
    
    Locator* locator = [[Locator alloc] init];
    
    
    NSString *strLocation;
    
    if ([locator getCoordinates: &location])
        
    {
        
        strLocation = [NSString stringWithFormat:@"%f,%f",location.latitude,location.longitude];
        
    }
    
    else
        
    {
        
        strLocation = @"failed";
        
    }
    
    
    //    NSLog(@"location = %@",strLocation);
    
    return strLocation;
    
}

-(void) openGPSApp:(int)type toLocation:(NSString *)toLocation

{
    
    NSString *strDeviceLocation = [appDelegate getCurrentLocationOfDevice];
    
    NSString *strDeviceLocationLat = [[strDeviceLocation componentsSeparatedByString:@","] objectAtIndex:0];
    
    NSString *strDeviceLocationLon = [[strDeviceLocation componentsSeparatedByString:@","] objectAtIndex:1];
    
    //get distance
    
    CLLocation *destinationLocation;
    
    CLLocationCoordinate2D location;
    
    NSArray *arrLocation = [toLocation componentsSeparatedByString:@","];
    
    location.latitude = [[arrLocation objectAtIndex:0] doubleValue];
    
    location.longitude = [[arrLocation objectAtIndex:1] doubleValue];
    
    destinationLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    
    
    CLLocation *MyLocation;
    
    location.latitude = [strDeviceLocationLat doubleValue];
    
    location.longitude = [strDeviceLocationLon doubleValue];
    
    MyLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    
    
    
    float dist = [MyLocation distanceFromLocation:destinationLocation];
    
    
    
    NSString* byFoot;
    
    if (dist <= 200)
        
        byFoot = @"&dirflg=w";
    
    else
        
        byFoot = @"";
    
    
    
    
    
    NSString* mapsURL;
    
    if (type == 1)
    {
        NSString *wazeAppURL = @"waze://";
        
        BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:wazeAppURL]];
        if (canOpenURL) {
            mapsURL = [NSString stringWithFormat:@"waze://?ll=%@,%@&navigate=yes",
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.latitude],
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.longitude]];
        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Waze" message:@"No application Waze on your device \n Please Download" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    
    else
        
    {
        UIDevice *myDevice=[UIDevice currentDevice];
        NSString *systemVersion=[myDevice systemVersion];
        if ([[systemVersion substringToIndex:1]intValue]<6){
            mapsURL = [NSString stringWithFormat:@"http://maps.google.com?hl=iw&saddr=%@,%@&daddr=%@,%@%@",
                       
                       [NSString stringWithFormat:@"%f", MyLocation.coordinate.latitude],
                       
                       [NSString stringWithFormat:@"%f", MyLocation.coordinate.longitude],
                       
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.latitude],
                       
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.longitude],
                       
                       byFoot];
        }else{
            mapsURL = [NSString stringWithFormat:@"http://maps.apple.com?hl=iw&saddr=%@,%@&daddr=%@,%@%@",
                       
                       [NSString stringWithFormat:@"%f", MyLocation.coordinate.latitude],
                       
                       [NSString stringWithFormat:@"%f", MyLocation.coordinate.longitude],
                       
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.latitude],
                       
                       [NSString stringWithFormat:@"%f", destinationLocation.coordinate.longitude],
                       
                       byFoot];
        }
    }
    
    NSLog(@"opening maps: %@", mapsURL);
    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [mapsURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [@"https://itunes.apple.com/us/app/waze-social-gps-traffic-gas/id323229106?mt=8" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}


- (void) runTimerInBackground {
    //    [self performSelectorInBackground:@selector(sendLatLon) withObject:nil];
    [self performSelectorOnMainThread:@selector(sendLatLon) withObject:nil waitUntilDone:NO];
}

- (void) sendLatLon {
    _locationTimar = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(GetLocation) userInfo:nil repeats:YES];
    [_locationTimar fire];
}

-(void)GetLocation{
    NSLog(@"GetLocation:");
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 100 m
    [locationManager startUpdatingLocation];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    
    _lat = [NSString stringWithFormat:@"%f", zoomLocation.latitude];
    _longt = [NSString stringWithFormat:@"%f", zoomLocation.longitude];
    
//    [SenderBrain setUserLocation:_lat :_lng];
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
    
    _lat = [NSString stringWithFormat:@"%f", zoomLocation.latitude];
    _longt = [NSString stringWithFormat:@"%f", zoomLocation.longitude];
    NSLog(@"lat2: %@, longt2: %@",_lat ,_longt);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error description]);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"אין מיקום נוכחי" message:@"כדי להשתמש באפליקציה אשר שימוש בשירותי מיקום בהגדרות"delegate:self cancelButtonTitle:@"אישור" otherButtonTitles: nil];
    [alert show];
}

-(void)addLinearGradientToView:(UIView*)view TopColor:(UIColor*)topColor BottomColor:(UIColor*)bottomColor
{
    for(CALayer* layer in view.layer.sublayers)
    {
        if ([layer isKindOfClass:[CAGradientLayer class]])
        {
            [layer removeFromSuperlayer];
        }
    }
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    //top down gradient
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5,1);
    gradientLayer.frame = view.bounds;
    
    
    
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    
    [view.layer insertSublayer:gradientLayer atIndex:0];
    
}

-(CAGradientLayer *)setupGradientButton:(UIButton *)btnType gradientType:(NSString *)gType {
    
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    // use that btn property for its bounds, easier and more flexible this way
    gradientLayer.frame = btnType.layer.bounds;
    
    [gradientLayer setLocations:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0f],
                                 [NSNumber numberWithFloat:0.5f],
                                 nil]
     ];
    
    // our colors dictionary has this composite key- button type, high/low color, and layer (highlight
    // or "normal")
    NSString *low_key = [NSString stringWithFormat:@"low_%@",gType];
    NSString *high_key = [NSString stringWithFormat:@"high_%@", gType];
    
    // use gradient layer's "colors" method to let QuartzCore build the gradient
    [gradientLayer setColors:
     [NSArray arrayWithObjects:
      (id)[[colors objectForKey:high_key] CGColor],
      (id)[[colors objectForKey:low_key] CGColor],
      nil]];
    
    return gradientLayer;
}

-(void)setupColors{
    colors = [[NSDictionary alloc] initWithObjectsAndKeys:
              [UIColor colorWithHex:@"#ee4d06" alpha:1.0], @"low_normal"
              ,[UIColor colorWithHex:@"#ff8752" alpha:1.0], @"high_normal"
              ,[UIColor colorWithHex:@"#ff8752" alpha:1.0], @"low_high"
              ,[UIColor colorWithHex:@"#ee4d06" alpha:1.0], @"high_high"
              //              ,[UIColor colorWithRed:0.66 green:0.44 blue:0.42 alpha:1.0], @"rec_border"
              //              ,[UIColor colorWithRed:0.39 green:0.51 blue:0.30 alpha:1.0], @"play_low_normal"
              //              ,[UIColor colorWithRed:0.49 green:0.65 blue:0.38 alpha:1.0], @"play_high_normal"
              //              ,[UIColor colorWithRed:0.33 green:0.44 blue:0.36 alpha:1.0], @"play_low_high"
              //              ,[UIColor colorWithRed:0.39 green:0.51 blue:0.30 alpha:1.0], @"play_high_high"
              //              ,[UIColor colorWithRed:0.40 green:0.54 blue:0.30 alpha:1.0], @"play_border"
              //              ,[UIColor colorWithRed:0.49 green:0.50 blue:0.50 alpha:1.0], @"stop_low_normal"
              //              ,[UIColor colorWithRed:0.57 green:0.59 blue:0.59 alpha:1.0], @"stop_high_normal"
              //              ,[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0], @"stop_low_high"
              //              ,[UIColor colorWithRed:0.50 green:0.51 blue:0.51 alpha:1.0], @"stop_high_high"
              //              ,[UIColor colorWithRed:0.41 green:0.42 blue:0.42 alpha:1.0], @"stop_border"
              //              ,[UIColor colorWithRed:0.44 green:0.63 blue:0.65 alpha:1.0], @"share_low_normal"
              //              ,[UIColor colorWithRed:0.62 green:0.80 blue:0.82 alpha:1.0], @"share_high_normal"
              //              ,[UIColor colorWithRed:0.24 green:0.32 blue:0.33 alpha:1.0], @"share_low_high"
              //              ,[UIColor colorWithRed:0.40 green:0.54 blue:0.56 alpha:1.0], @"share_high_high"
              //              ,[UIColor colorWithRed:0.49 green:0.65 blue:0.67 alpha:1.0], @"share_border"
              , nil];
}

- (NSString *)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude
{
    SBJSON *parser = [[SBJSON alloc] init];
    
    // Prepare URL request
    
    //http://maps.googleapis.com/maps/api/geocode/json?latlng=32.090889,34.858384&sensor=false
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=false",pdblLatitude, pdblLongitude];
    
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=false",pdblLatitude, pdblLongitude]]];
    //    //    NSLog(@"url search %@",request);
    //    // Perform request and get JSON back as a NSData object
    //    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    //    if (response != nil) {
    //    // Get JSON as a NSString from NSData response
    //    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding error:&error];
    
    //Print contents of json-string
    NSArray *Users = [parser objectWithString:locationString error:nil];
    NSString *fullAddress;
    NSArray *googleArray = [Users valueForKey:@"results"];
    if ([[Users valueForKey:@"status"] isEqualToString:@"OK"]) {
        fullAddress = [[googleArray objectAtIndex:0] valueForKey:@"formatted_address"];
    } else {
        fullAddress = @"";
    }
    NSLog(@"fullAddress: %@",fullAddress);
    //    fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [fullAddress substringFromIndex:6];
    return fullAddress;
}

- (NSString *)getDistanceFromOrigins:(NSString *)origins withDestinations:(NSString *)destinations
{
    //    NSMutableString *stringToSend = [[NSMutableString alloc] init];
    //
    //    origins = [origins stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    origins = [origins stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //    destinations = [destinations stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    destinations = [destinations stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //
    //    [stringToSend appendFormat:@"origins=%@",origins];
    //    [stringToSend appendFormat:@"&destinations=%@",destinations];
    //    [stringToSend appendFormat:@"&mode=driving&language=he-IL&sensor=false"];
    //    NSLog(@"DEBUG !http://maps.googleapis.com/maps/api/distancematrix/json?%@! link to send",stringToSend);
    //
    //    NSString *post = stringToSend;
    //    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //
    //    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    //
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    [request setURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/distancematrix/json"]];
    //    [request setHTTPMethod:@"POST"];
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    [request setHTTPBody:postData];
    //
    //    //        NSLog(@"%@", request);
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //    NSLog(@"returnString: %@",returnString);
    SBJSON *parser = [[SBJSON alloc] init];
    
    // Prepare URL request
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&mode=driving&language=he-IL&sensor=false",origins ,destinations];
    
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"locationString: %@",locationString);
    //Print contents of json-string
    NSArray *Users = [parser objectWithString:locationString error:nil];
    
    NSArray *fullAddress = [[NSArray alloc]init];
    NSString *distance;
    NSArray *googleArray = [Users valueForKey:@"rows"];
    
    if ([[Users valueForKey:@"status"] isEqualToString:@"OK"]) {
        fullAddress = [[googleArray objectAtIndex:0] valueForKey:@"elements"];
        if ([[[fullAddress objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"OK"]) {
            distance = [[fullAddress objectAtIndex:0] valueForKey:@"duration"];
        }else {
            distance = @"";
        }
    } else {
        distance = @"";
    }
    NSLog(@"fullAddress: %@",distance);
    //    fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [fullAddress substringFromIndex:6];
    return distance;
}

- (NSString *)getMetterDistanceFromOrigins:(NSString *)origins withDestinations:(NSString *)destinations
{
    origins = [origins stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    origins = [origins stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    destinations = [destinations stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    destinations = [destinations stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    SBJSON *parser = [[SBJSON alloc] init];
    
    // Prepare URL request
    
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/distancematrix/json?origins=%@&destinations=%@&mode=driving&language=he-IL&sensor=false",origins ,destinations];
    
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[urlString  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"locationString: %@",locationString);
    //Print contents of json-string
    NSArray *Users = [parser objectWithString:locationString error:nil];
    
    NSArray *fullAddress = [[NSArray alloc]init];
    NSString *distance;
    NSArray *googleArray = [Users valueForKey:@"rows"];
    
    if ([[Users valueForKey:@"status"] isEqualToString:@"OK"]) {
        fullAddress = [[googleArray objectAtIndex:0] valueForKey:@"elements"];
        if ([[[fullAddress objectAtIndex:0] valueForKey:@"status"] isEqualToString:@"OK"]) {
            distance = [[fullAddress objectAtIndex:0] valueForKey:@"distance"];
            distance = [distance valueForKey:@"value"];
        }else {
            distance = @"";
        }
    } else {
        distance = @"";
    }
    NSLog(@"fullAddress: %@",distance);
    //    fullAddress = [fullAddress stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    [fullAddress substringFromIndex:6];
    return distance;
}

- (NSString *) geoCodeUsingAddressToLatLong:(NSString *)address
{
    NSString *statusResult;
    NSString *latFromAddress;
    NSString *longFromAddress;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSLog(@"address: %@",esc_addr);
    NSLog(@"url: %@",req);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        SBJSON *parser = [[SBJSON alloc] init];
        NSArray *catagory = [parser objectWithString:result error:nil];
        NSString *resultStatus = [catagory valueForKey:@"status"];
        if ([resultStatus isEqualToString:@"ZERO_RESULTS"]) {
            statusResult = @"ZERO_RESULTS";
        }
        else{
            NSArray *resultAddress = [catagory valueForKey:@"results"];
            latFromAddress = [NSString stringWithFormat:@"%@",[[[[resultAddress valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] objectAtIndex:0]];
            longFromAddress = [NSString stringWithFormat:@"%@",[[[[resultAddress valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"] objectAtIndex:0]];
            NSLog(@"lat: %@",latFromAddress);
            NSLog(@"lng: %@",longFromAddress);
            statusResult = [NSString stringWithFormat:@"%@,%@",latFromAddress,longFromAddress];
        }
    }
    return statusResult;
}

@end
