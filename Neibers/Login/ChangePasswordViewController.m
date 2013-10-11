//
//  ChangePasswordViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 07/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "SenderBrain.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    _oldPasswordTextField.delegate = self;
    _passwordNewTextField.delegate = self;
    _reNewPasswordTextField.delegate = self;
    
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"high"] atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"normal"] atIndex:1];
    
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];
    self.headerLabel.text = LocalizedString(@"Change Password");
    self.oldLabelPassword.text = LocalizedString(@"Old Password");
    self.passwordNewLabel.text = LocalizedString(@"New Password");
    self.reNewPasswordLabel.text = LocalizedString(@"Return New Password");
}

- (void)viewDidUnload {
    [self setOkButton:nil];
    [self setHeaderLabel:nil];
    [self setBackButton:nil];
    [self setOldLabelPassword:nil];
    [self setOldPasswordTextField:nil];
    [self setPasswordNewLabel:nil];
    [self setPasswordNewTextField:nil];
    [self setReNewPasswordLabel:nil];
    [self setReNewPasswordTextField:nil];
    [super viewDidUnload];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)clickBackground:(id)sender
{
    [_oldPasswordTextField resignFirstResponder];
    [_passwordNewTextField resignFirstResponder];
    [_reNewPasswordTextField resignFirstResponder];
}

- (IBAction)changePasswordButtonPress:(id)sender {
    if (StringIsNilOrEmpty(_oldPasswordTextField.text) || StringIsNilOrEmpty(_passwordNewTextField.text) || StringIsNilOrEmpty(_reNewPasswordTextField.text)) {
        
        if (StringIsNilOrEmpty(_oldPasswordTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Old Password" message:@"Enter Old Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (StringIsNilOrEmpty(_passwordNewTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"New Password" message:@"Enter New Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (StringIsNilOrEmpty(_reNewPasswordTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Return New Password" message:@"Enter Renew Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        if (![_reNewPasswordTextField.text isEqualToString:_passwordNewTextField.text]) {
            
        } else {

                NSString *status = [SenderBrain changePassword:_oldPasswordTextField.text :_passwordNewTextField.text];
            
            if ([status isEqualToString:@"OK"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Your Password Change" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            else if ([status isEqualToString:@"Not Equal"]) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Pleas write correct Old Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erorr" message:@"Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _oldPasswordTextField) {
        
    }else if (textField == _passwordNewTextField) {
        
    }else if (textField == _reNewPasswordTextField) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _oldPasswordTextField) {
        
    }else if (textField == _passwordNewTextField) {
        
    }else if (textField == _reNewPasswordTextField) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
