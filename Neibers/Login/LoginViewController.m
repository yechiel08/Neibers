//
//  LoginViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "LoginViewController.h"
#import "NewUserViewController.h"

#import "MapViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "SenderBrain.h"
#import "ForgatPasswordViewController.h"

#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userNameTextField, passwordTextField;

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
    userNameTextField.delegate = self;
    passwordTextField.delegate = self;
    [self.navigationController setNavigationBarHidden:TRUE];

//    CAGradientLayer *buttonLoginGradient = [CAGradientLayer layer];
//    buttonLoginGradient.frame = self.okButton.bounds;
//    buttonLoginGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"#ff8752" alpha:1.0] CGColor], (id)[[UIColor colorWithHex:@"#ee4d06" alpha:1.0] CGColor], nil];
//    [self.okButton.layer insertSublayer:buttonLoginGradient atIndex:0];
    
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"high"] atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"normal"] atIndex:1];
    
//    [self.navigationController setNavigationBarHidden:TRUE];
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];
    [self.forgotButton setTitle:LocalizedString(@"Forgot Password") forState:UIControlStateNormal];
    self.headerLabel.text = LocalizedString(@"Login");
    self.emailLabel.text = LocalizedString(@"Email");
    self.passwordLabel.text = LocalizedString(@"Password");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.forgotButton setTitle:LocalizedString(@"Forgot Password") forState:UIControlStateNormal];
    self.headerLabel.text = LocalizedString(@"Login");
    self.emailLabel.text = LocalizedString(@"Email");
    self.passwordLabel.text = LocalizedString(@"Password");
}

-(IBAction)login:(id)sender{
    NSString *returnLogin = [SenderBrain checkUser:userNameTextField.text];
    if ([returnLogin isEqualToString:@"true"]) {
        
//        NSMutableDictionary *firstTimeDic;
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path=[NSString stringWithFormat:@"%@/%@",[paths objectAtIndex:0],@"newUserFiles.plist"];
//        
//        //checking for exist of the user data as DEVICE_FILE_NAME
//        if ([[NSFileManager defaultManager]fileExistsAtPath:path]){
//            firstTimeDic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
//        }
//        else {
//            //        NSLog(@"no file NEW_USER_FILE_NAME");
//            firstTimeDic = [[NSMutableDictionary alloc] init];
//        }
//        
//        [firstTimeDic setObject:userNameTextField.text forKey:KEY_EMAIL];
//        [firstTimeDic setObject:passwordTextField.text forKey:KEY_PASSWORD];
//        [firstTimeDic writeToFile:path atomically:YES];
        NSString *status = [SenderBrain checkUser:userNameTextField.text :passwordTextField.text];
        if ([status isEqualToString:@"AccessToken"]) {
//            [SenderBrain loudUserProfile];
            [[NSUserDefaults standardUserDefaults] setValue:@"SignIn" forKey:@"StatusSign"];
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Later"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            MapViewController *frontViewController = [[MapViewController alloc] init];
            RearViewController *rearViewController = [[RearViewController alloc] init];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            
            RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
            self.viewController = revealController;
            
            //	self.window.rootViewController = self.viewController;
            
            //        HomeViewController *homeViewController = [[HomeViewController alloc] init];
            [self.navigationController pushViewController:revealController animated:NO];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erorr" message:@"Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else if ([statusUser isEqualToString:@"false"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"User name not exists please replace User Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(IBAction)nextClicked
{
    [passwordTextField becomeFirstResponder];
}

-(IBAction)clickBackground:(id)sender
{
    [userNameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == userNameTextField) {
        
    }
    else if (textField == passwordTextField) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == userNameTextField) {
        statusUser = [SenderBrain checkUser:userNameTextField.text];
        if ([statusUser isEqualToString:@"Exists"]) {
            BOOL email = [self validateEmailWithString:userNameTextField.text];
            if (email == NO) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Name Not invild" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                userNameTextField.text = @"";
            }
        }
        else if ([statusUser isEqualToString:@"Not Exists"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"User name Not Exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    else if (textField == passwordTextField) {
        
    }
}

-(IBAction)forgatPassword:(id)sender
{
    ForgatPasswordViewController *forgotPasswordViewController = [[ForgatPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
//    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter your email", @"new_list_dialog")
//                                                          message:@"this gets covered" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    userEmeilTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
//    [userEmeilTextField setBackgroundColor:[UIColor whiteColor]];
//    [myAlertView addSubview:userEmeilTextField];
//    [myAlertView show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 1) {
    //        [SenderBrain PasswordRestore:userEmeilTextField.text];
    //    }
}

-(IBAction)NewUser:(id)sender{
    NewUserViewController *newLoginViewController = [[NewUserViewController alloc] init];
    [self.navigationController pushViewController:newLoginViewController animated:YES];
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    [self setOkButton:nil];
    [self setBackButton:nil];
    [self setHeaderLabel:nil];
    [self setEmailLabel:nil];
    [self setPasswordLabel:nil];
    [self setForgotButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
