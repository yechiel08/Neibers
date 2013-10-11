//
//  ForgatPasswordViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 21/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "ForgatPasswordViewController.h"
#import "SenderBrain.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ForgatPasswordViewController ()

@end

@implementation ForgatPasswordViewController

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
    _emailTextField.delegate = self;
    [self.navigationController setNavigationBarHidden:TRUE];

//    CAGradientLayer *buttonLoginGradient = [CAGradientLayer layer];
//    buttonLoginGradient.frame = self.okButton.bounds;
//    buttonLoginGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"#ff8752" alpha:1.0] CGColor], (id)[[UIColor colorWithHex:@"#ee4d06" alpha:1.0] CGColor], nil];
//    [self.okButton.layer insertSublayer:buttonLoginGradient atIndex:0];

    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"high"] atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"normal"] atIndex:1];
    
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];
    self.forgotLabel.text = LocalizedString(@"Forgot your password?");
    self.headerLabel.text = LocalizedString(@"Login");
    self.fillEmailLabel.text = LocalizedString(@"Fill in your email address");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setOkButton:nil];
    [self setEmailTextField:nil];
    [self setHeaderLabel:nil];
    [self setBackButton:nil];
    [self setForgotLabel:nil];
    [self setFillEmailLabel:nil];
    [super viewDidUnload];
}

- (IBAction)sendEmailbuttonPress:(id)sender {
    [SenderBrain PasswordRestore:_emailTextField.text];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)clickBackground:(id)sender
{
    [_emailTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _emailTextField) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _emailTextField) {
        
    }
}

@end
