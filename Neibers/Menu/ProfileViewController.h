//
//  ProfileViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 27/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class RevealController;

@interface ProfileViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
{
    NSString *statusUser;
}

@property (strong, nonatomic) NSData *dataImage;
@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutlet UILabel *emailButton;
@property (strong, nonatomic) IBOutlet UILabel *pictureLabel;

@property (nonatomic, retain) IBOutlet UITextField *userNameTextField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UILabel *emailTextField;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;

-(IBAction)clickBackground:(id)sender;
-(IBAction)changeProfile:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)changePasswordButtonPress:(id)sender;

@end
