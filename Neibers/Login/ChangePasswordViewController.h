//
//  ChangePasswordViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 07/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *oldLabelPassword;
@property (strong, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (strong, nonatomic) IBOutlet UILabel *passwordNewLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (strong, nonatomic) IBOutlet UILabel *reNewPasswordLabel;
@property (strong, nonatomic) IBOutlet UITextField *reNewPasswordTextField;

- (IBAction)back:(id)sender;
-(IBAction)clickBackground:(id)sender;
- (IBAction)changePasswordButtonPress:(id)sender;

@end
