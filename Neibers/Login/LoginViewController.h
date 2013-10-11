//
//  LoginViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class RevealController;

@interface LoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
{
    UITextField *userEmeilTextField;
    NSString *statusUser;
    NSDictionary *colors;
}
@property (strong, nonatomic) RevealController *viewController;

@property (nonatomic, retain) IBOutlet UITextField *userNameTextField, *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UIButton *forgotButton;

-(IBAction)nextClicked;
-(IBAction)clickBackground:(id)sender;
-(IBAction)NewUser:(id)sender;
-(IBAction)forgatPassword:(id)sender;
-(IBAction)login:(id)sender;
- (IBAction)backButton:(id)sender;

@end
