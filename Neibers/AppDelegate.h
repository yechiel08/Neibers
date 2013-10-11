//
//  AppDelegate.h
//  Neibers
//
//  Created by Yechiel Amar on 14/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Locator.h"
#import <Accounts/Accounts.h>
#import <Foundation/Foundation.h>
#import "Extentions.h"
#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"

extern NSString *const FBSessionStateChangedNotification;

@class RevealController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    NSDictionary *colors;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSString *deviceTokenSingture;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *longt;
@property (strong, nonatomic) NSString *userProfileDetils;
@property (strong, nonatomic) RevealController *viewController;
@property (nonatomic, assign) int statusUser;

@property (nonatomic, strong) NSArray *userProfile;
@property (nonatomic, strong) NSMutableDictionary *userPath;

@property (nonatomic, strong) NSTimer *locationTimar;

-(NSData *) repalseUrlStringToData: (NSString *)urlString;
-(UIImage *) repalseDateToImage: (NSData *)dataImage;

-(void) openGPSApp:(int)type toLocation:(NSString *)toLocation;
-(NSString *)getCurrentLocationOfDevice;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

- (NSString *)getNibNameWithName:(NSString *)name;
-(void)addLinearGradientToView:(UIView*)view TopColor:(UIColor*)topColor BottomColor:(UIColor*)bottomColor;
-(CAGradientLayer *)setupGradientButton:(UIButton *)btnType gradientType:(NSString *)gType;

- (NSString *)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude;
- (NSString *)getDistanceFromOrigins:(NSString *)origins withDestinations:(NSString *)destinations;
- (NSString *)getMetterDistanceFromOrigins:(NSString *)origins withDestinations:(NSString *)destinations;
- (NSString *) geoCodeUsingAddressToLatLong:(NSString *)address;

@end
