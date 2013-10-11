//
//  StartViewController.h
//  Movon
//
//  Created by Yechiel Amar on 06/05/13.
//  Copyright (c) 2013 Yechiel  Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "SenderBrain.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "NewUserViewController.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "GradientButton.h"

@class RevealController;

@interface StartViewController : UIViewController
{
    NSDictionary *colors;
}
@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *userNameButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *laterButton;

- (IBAction)loginWithFacebook:(id)sender;
- (IBAction)loginNewUser:(id)sender;
- (IBAction)laterButtonPress:(id)sender;
- (IBAction)signIn:(id)sender;

@end
