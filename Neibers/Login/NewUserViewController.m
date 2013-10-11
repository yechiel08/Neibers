//
//  NewUserViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "NewUserViewController.h"

#import "MapViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "SenderBrain.h"
#import "NewCommunitiesViewController.h"
#import "AppDelegate.h"

@interface NewUserViewController ()

@end

@implementation NewUserViewController

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    [appDelegate openSessionWithAllowLoginUI:NO];
    
    _userNameTextField.delegate = self;
    _emailTextField.delegate = self;
    
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
    [self.facebookButton setTitle:LocalizedString(@"Use Facebook account to login") forState:UIControlStateNormal];
    [self.termServieButton setTitle:LocalizedString(@"I agree to the terms of use") forState:UIControlStateNormal];
    self.emailButton.text = LocalizedString(@"Email");
    self.pictureLabel.text = LocalizedString(@"Picture");
    self.headerLabel.text = LocalizedString(@"New User");
    self.userNameLabel.text = LocalizedString(@"User Name");
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.facebookButton setTitle:LocalizedString(@"Use Facebook account to login") forState:UIControlStateNormal];
    [self.termServieButton setTitle:LocalizedString(@"I agree to the terms of use") forState:UIControlStateNormal];
    self.emailButton.text = LocalizedString(@"Email");
    self.pictureLabel.text = LocalizedString(@"Picture");
    self.headerLabel.text = LocalizedString(@"New User");
    self.userNameLabel.text = LocalizedString(@"User Name");
}


-(IBAction)login:(id)sender{
    if (StringIsNilOrEmpty(_emailTextField.text) || StringIsNilOrEmpty(_userNameTextField.text) || imageData == nil) {
        
        if (StringIsNilOrEmpty(_userNameTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Name" message:@"Enter Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (StringIsNilOrEmpty(_emailTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"Enter Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (imageData == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image" message:@"Select Image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        statusUser = [SenderBrain checkUser:_emailTextField.text];
        if ([statusUser isEqualToString:@"true"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"User name already exists please replace User Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            BOOL email = [self validateEmailWithString:_emailTextField.text];
            if (email == NO) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Email Not invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                _emailTextField.text = @"";
            }
            else {
                
                NSString *status = [SenderBrain UpdateNewUser:_emailTextField.text :@"" :_userNameTextField.text :imageData :0];
                
                if ([status isEqualToString:@"AccessToken"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"SignIn" forKey:@"StatusSign"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Later"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NewCommunitiesViewController *newLoginViewController = [[NewCommunitiesViewController alloc] init];
                    newLoginViewController.isFirst = YES;
                    [self.navigationController pushViewController:newLoginViewController animated:YES];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erorr" message:@"Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                
            }
        }
    }
}

-(IBAction)nextClicked
{
    [_emailTextField becomeFirstResponder];
}

-(IBAction)clickBackground:(id)sender
{
    [_userNameTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _userNameTextField) {
        
    }
    else if (textField == _emailTextField) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        //        statusUser = [SenderBrain checkUser:userNameTextField.text];
        //        if ([statusUser isEqualToString:@"Exists"]) {
        //            BOOL email = [self validateEmailWithString:userNameTextField.text];
        //            if (email == NO) {
        //                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"User Name Not invild" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //                [alert show];
        //                userNameTextField.text = @"";
        //            }
        //        }
        //        else if ([statusUser isEqualToString:@"Not Exists"]){
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Email" message:@"User name Not Exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            [alert show];
        //        }
    }
    
    else if (textField == _emailTextField) {
        
    }
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (IBAction)addPhoto:(id)sender {
    [self clickBackground:sender];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select source image"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Roll Camera", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    if (buttonIndex != 2) {
        switch (buttonIndex) {
            case 0:
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                break;
            case 1:
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = YES;
                break;
        }
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        [self presentModalViewController:imagePicker animated:YES];
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    [actionSheet dismissWithClickedButtonIndex:2 animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissModalViewControllerAnimated:YES];
    //    UIImage *smallImage = image;
    //    UIImage *bigImage = image;
    image = [self resizeImage:image width:120 height:120];
    
    [_profileButton setImage:image forState:UIControlStateNormal];
    
    imageData = UIImageJPEGRepresentation(image, 0.9);
}

-(UIImage *)resizeImage:(UIImage *)anImage width:(int)width height:(int)height
{
    
    CGImageRef imageRef = [anImage CGImage];
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL, width, height, CGImageGetBitsPerComponent(imageRef), 4 * width, CGImageGetColorSpace(imageRef), alphaInfo);
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, width, height), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (void)viewDidUnload
{
    [self setOkButton:nil];
    [self setEmailTextField:nil];
    [self setProfileButton:nil];
    [self setBackButton:nil];
    [self setHeaderLabel:nil];
    [self setUserNameLabel:nil];
    [self setEmailButton:nil];
    [self setPictureLabel:nil];
    [self setFacebookButton:nil];
    [self setTermServieButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"FBSession.activeSession.isOpen");
    } else {
        NSLog(@"FBSession.activeSession.close");
    }
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
                NSLog(@"HOME: User session found");
                [self updateView];
            }
            break;
        case FBSessionStateClosed:
            NSLog(@"User session Closed");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        case FBSessionStateClosedLoginFailed:
            NSLog(@"User session ClosedLoginFailed");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        
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

// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView {
    
    
    
    
    NSArray *arrayUser = [SenderBrain getUserFaceBook];
    NSString *userFaceBookName = [arrayUser valueForKey:@"name"];
    NSString *userFaceBookID = [arrayUser valueForKey:@"id"];
    NSString *userFaceBookEmail = [arrayUser valueForKey:@"email"];
    NSString *userFaceBookBirthday = [arrayUser valueForKey:@"birthday"];
    //    NSString *userFaceBookPhone = @"";
    if (userFaceBookName  == nil) {
        userFaceBookName = @"";
    }
    if (userFaceBookID  == nil) {
        userFaceBookID = @"";
    }
    if (userFaceBookEmail  == nil) {
        userFaceBookEmail = @"";
    }
    if (userFaceBookBirthday  == nil) {
        userFaceBookBirthday = @"";
    }
    
    
    NSLog(@"arrayUser=%@",arrayUser);
    
    
    imageData = [self repalseUrlStringToData:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150",[arrayUser valueForKey:@"username"]]];
    
    if (imageData!=nil) {
        
        NSString *status = [SenderBrain UpdateNewUser:userFaceBookEmail :@"" :userFaceBookName :imageData :0];
        
        if ([status isEqualToString:@"AccessToken"]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"SignIn" forKey:@"StatusSign"];
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Later"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NewCommunitiesViewController *newLoginViewController = [[NewCommunitiesViewController alloc] init];
            [self.navigationController pushViewController:newLoginViewController animated:YES];

            
//            MapViewController *frontViewController = [[MapViewController alloc] init];
//            RearViewController *rearViewController = [[RearViewController alloc] init];
//            
//            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
//            
//            RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
//            self.viewController = revealController;
//            
//            [self.navigationController pushViewController:revealController animated:NO];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erorr" message:@"Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    else
    {
        [appDelegate openSessionWithAllowLoginUI:NO];
        
        UIAlertView*alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Facebook error connection, please try later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (NSData *) repalseUrlStringToData: (NSString *)urlString{
    NSURL *Imageurl = [NSURL URLWithString:urlString];
    NSData *data =  [NSData dataWithContentsOfURL:Imageurl];
    if ( data == nil )
    {
        UIImage *image = [UIImage imageNamed:@"AdPictureFrame"];
        data = UIImageJPEGRepresentation(image, 0.9);
    }
    return data;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithFacebook:(id)sender {
    
    
    NSLog(@"loginWithFacebook");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self openSessionWithAllowLoginUI:YES];
    
    
    
    //    [appDelegate closeSession];
}

@end
