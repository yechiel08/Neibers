//
//  NewUserViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class RevealController;

@interface NewUserViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    NSData *imageData;
    NSString *statusUser;
}

@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UILabel *emailButton;
@property (strong, nonatomic) IBOutlet UILabel *pictureLabel;

@property (nonatomic, retain) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UIButton *termServieButton;

-(IBAction)nextClicked;
-(IBAction)clickBackground:(id)sender;
-(IBAction)login:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)loginWithFacebook:(id)sender;

@end
