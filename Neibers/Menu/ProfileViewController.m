//
//  ProfileViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 27/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "ProfileViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "SenderBrain.h"
#import "AppDelegate.h"
#import "ChangePasswordViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    
    _emailTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Email"];
    _userNameTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Name"];

    NSString *stringEncodingUrl = [[[NSUserDefaults standardUserDefaults] valueForKey:@"Image Path"] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *Imageurl = [NSURL URLWithString:stringEncodingUrl];
    _dataImage =  [NSData dataWithContentsOfURL:Imageurl];
    UIImage *image = [UIImage imageWithData:_dataImage];
    [_profileButton setImage:image forState:UIControlStateNormal];
    
    [self.navigationController setNavigationBarHidden:TRUE];
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        
        [_menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addGestureRecognizer:navigationBarPanGestureRecognizer];
	}
    _userNameTextField.delegate = self;
    //    CAGradientLayer *buttonLoginGradient = [CAGradientLayer layer];
    //    buttonLoginGradient.frame = self.okButton.bounds;
    //    buttonLoginGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"#ff8752" alpha:1.0] CGColor], (id)[[UIColor colorWithHex:@"#ee4d06" alpha:1.0] CGColor], nil];
    //    [self.okButton.layer insertSublayer:buttonLoginGradient atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"high"] atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"normal"] atIndex:1];
    //    [self.navigationController setNavigationBarHidden:TRUE];
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    self.emailButton.text = LocalizedString(@"Email");
    self.pictureLabel.text = LocalizedString(@"Picture");
    self.headerLabel.text = LocalizedString(@"Profile");
    self.userNameLabel.text = LocalizedString(@"User Name");
    [self.changePasswordButton setTitle:LocalizedString(@"Change Password") forState:UIControlStateNormal];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    self.emailButton.text = LocalizedString(@"Email");
    self.pictureLabel.text = LocalizedString(@"Picture");
    self.headerLabel.text = LocalizedString(@"Profile");
    self.userNameLabel.text = LocalizedString(@"User Name");
    [self.changePasswordButton setTitle:LocalizedString(@"Change Password") forState:UIControlStateNormal];
}

-(IBAction)clickBackground:(id)sender
{
    [_userNameTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _userNameTextField) {
        
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        
    }
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

- (IBAction)changePasswordButtonPress:(id)sender {
    ChangePasswordViewController *newLoginViewController = [[ChangePasswordViewController alloc] init];
    [self.navigationController pushViewController:newLoginViewController animated:YES];
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
    _dataImage = UIImageJPEGRepresentation(image, 0.9);
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

-(IBAction)changeProfile:(id)sender{
    if (StringIsNilOrEmpty(_userNameTextField.text) || _dataImage == nil) {
        
        if (StringIsNilOrEmpty(_userNameTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Name" message:@"Enter Name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (_dataImage == nil) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Image" message:@"Select Image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {

        NSString *status = [SenderBrain UpdateNewUser:_emailTextField.text :@"" :_userNameTextField.text :_dataImage :1];
        
        if ([status isEqualToString:@"AccessToken"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Profile Change" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Erorr" message:@"Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)viewDidUnload
{
    [self setOkButton:nil];
    [self setEmailTextField:nil];
    [self setProfileButton:nil];
    [self setHeaderLabel:nil];
    [self setUserNameLabel:nil];
    [self setEmailButton:nil];
    [self setPictureLabel:nil];
    [self setChangePasswordButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
