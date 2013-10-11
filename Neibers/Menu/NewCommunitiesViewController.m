//
//  MyCommunitiesViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 26/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "NewCommunitiesViewController.h"
#import "RearViewController.h"
#import "RevealController.h"
#import "MapViewController.h"
#import "InAppPurchaseManager.h"

@interface NewCommunitiesViewController ()

@end

@implementation NewCommunitiesViewController

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
    imageData = [[NSData alloc] init];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 568){
        _control.frame = CGRectMake(_control.bounds.origin.x, 45, _control.bounds.size.width, 523);
        _scrollView.frame = CGRectMake(_scrollView.bounds.origin.x, 0, _scrollView.bounds.size.width, 523);
    }
    if (keyboardPickerToolbar == nil) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            keyboardPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 221, self.view.bounds.size.width, 44)];
        else
            keyboardPickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(118, 86, 296, 44)];
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(clickBackground:)];
        [keyboardPickerToolbar setItems:[[NSArray alloc]
                                         initWithObjects:extraSpace, doneButton, nil]];
    }
    
    locationManager.delegate = self;
    [self.navigationController setNavigationBarHidden:TRUE];

    if (_isFirst) {
        _backButton.hidden = NO;
        _menuButton.hidden = YES;
        _skipButton.hidden = NO;
    }else {
        _backButton.hidden = YES;
        _menuButton.hidden = NO;
        _skipButton.hidden = YES;

        if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
        {
            UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
            
            [_menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addGestureRecognizer:navigationBarPanGestureRecognizer];
        }
    }
    
    _scrollView.contentSize = CGSizeMake(0,550);
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"high"] atIndex:0];
    [[_okButton layer] insertSublayer:[appDelegate setupGradientButton:_okButton gradientType:@"normal"] atIndex:1];
    [self.okButton setTitle:LocalizedString(@"OK") forState:UIControlStateNormal];
    [self.useMyLocationLabel setTitle:LocalizedString(@"Use my location") forState:UIControlStateNormal];
    [self.skipButton setTitle:LocalizedString(@"Skip") forState:UIControlStateNormal];
    self.pictureLabel.text = LocalizedString(@"Picture");
    self.typeOfCommunityLabel.text = LocalizedString(@"Type of Community");
    self.communityName.text = LocalizedString(@"Community name");
    self.addressLabel.text = LocalizedString(@"Address");
    self.descripitionCommunityLabel.text = LocalizedString(@"Description Community");
    self.openCommunity.text = LocalizedString(@"Open Community");
    self.closeCommunityLabel.text = LocalizedString(@"Closed Community");
    self.headerLabel.text = LocalizedString(@"New Communities");
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];

    _communityNameTextField.delegate = self;
    _addressTextField.delegate = self;
    _descripitionTextField.delegate = self;
    _linkTextField.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setOkButton:nil];
    [self setCommunityPicture:nil];
    [self setAddressTextField:nil];
    [self setPictureLabel:nil];
    [self setTypeOfCommunityLabel:nil];
    [self setCommunityName:nil];
    [self setAddressLabel:nil];
    [self setDescripitionCommunityLabel:nil];
    [self setHeaderLabel:nil];
    [self setUseMyLocationLabel:nil];
    [self setOpenCommunity:nil];
    [self setCloseCommunityLabel:nil];
    [self setSkipButton:nil];
    [self setCommunityNameTextField:nil];
    [self setDescripitionTextField:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

- (IBAction)okButtonPress:(id)sender {
    if (StringIsNilOrEmpty(_typeLabel.text) || StringIsNilOrEmpty(_communityNameTextField.text) || StringIsNilOrEmpty(_addressTextField.text)){
        
        if (StringIsNilOrEmpty(_typeLabel.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"Type of Community") message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (StringIsNilOrEmpty(_communityNameTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"Community name") message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (StringIsNilOrEmpty(_addressTextField.text)) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"Address") message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else {
        NSString *status = [SenderBrain setNewCommunity:_numberTypeLabel.text : _typeLabel.text :_communityNameTextField.text :_addressTextField.text :_descripitionTextField.text :_linkTextField.text :@"1" :latAddress :lonAddress :imageData];
        if ([status isEqualToString:@"OK"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"Successfully added") message:Nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            
        }
        //    }
        if (_isFirst) {
            MapViewController *frontViewController = [[MapViewController alloc] init];
            RearViewController *rearViewController = [[RearViewController alloc] init];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            
            RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
            self.viewController = revealController;
            
            [self.navigationController pushViewController:revealController animated:NO];
        } else {
            MapViewController *mapViewController = [[MapViewController alloc] init];
            [self.navigationController pushViewController:mapViewController animated:NO];
        }
    }
}

- (IBAction)myAddressButtonPress:(id)sender {
    CLLocationManager *location = [[CLLocationManager alloc]init];
    [location startUpdatingLocation];
    
    latAddress = [NSString stringWithFormat:@"%f", location.location.coordinate.latitude];
    lonAddress = [NSString stringWithFormat:@"%f", location.location.coordinate.longitude];
    NSLog(@"lat12: %@, longt12: %@",latAddress ,lonAddress);
    [self ShowAddresInView];
    
    [location stopUpdatingLocation];
}

- (IBAction)openCloseCommunity:(UIButton *)sender {
    if (sender.selected) {
//        [self changeSelected:sender.selected];
//        sender.selected = NO;
    } else {
        if (sender.tag == 2){
            [[InAppPurchaseManager sharedInstance] makeTransaction];
        }else {
            [self changeSelected:sender.selected];
            sender.selected = YES;
        }
    }
}

- (void)changeSelected: (BOOL) selcted {
    for (UIButton * button in self.scrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == 1 || button.tag == 2) {
                button.selected = selcted;
            }
        }
    }
}

-(void)ShowAddresInView{
    
    NSString *strAddressFromLatLong = [appDelegate getAddressFromLatLon:latAddress withLongitude:lonAddress];
    _addressTextField.text = strAddressFromLatLong;
}

- (IBAction)addPhoto:(id)sender {
//    [self clickBackground:sender];
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
    [_communityPicture setImage:image forState:UIControlStateNormal];
    
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
-(IBAction)clickBackground:(id)sender
{
    [_communityNameTextField resignFirstResponder];
    [_addressTextField resignFirstResponder];
    [_descripitionTextField resignFirstResponder];
    [_linkTextField resignFirstResponder];
    [keyboardPickerToolbar removeFromSuperview];
    [pickerView removeFromSuperview];
}

- (IBAction)backPress:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)skipButtonPress:(id)sender {
    MapViewController *frontViewController = [[MapViewController alloc] init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
    self.viewController = revealController;
    
    [self.navigationController pushViewController:revealController animated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _communityNameTextField) {
        [keyboardPickerToolbar removeFromSuperview];
        [pickerView removeFromSuperview];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y - 13.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }else if (textField == _addressTextField) {
        [keyboardPickerToolbar removeFromSuperview];
        [pickerView removeFromSuperview];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y - 114.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }else if (textField == _descripitionTextField) {
        [keyboardPickerToolbar removeFromSuperview];
        [pickerView removeFromSuperview];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y - 164.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }else if (textField == _linkTextField) {
        [keyboardPickerToolbar removeFromSuperview];
        [pickerView removeFromSuperview];

        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y - 216.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _communityNameTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y + 13.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }else if (textField == _addressTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y + 114.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
        NSString *LatLong = [appDelegate geoCodeUsingAddressToLatLong:_addressTextField.text];
        NSArray *arrLocation = [LatLong componentsSeparatedByString:@","];
        
        latAddress = [arrLocation objectAtIndex:0];
        
        lonAddress = [arrLocation objectAtIndex:1];
        
    }else if (textField == _descripitionTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y + 164.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }else if (textField == _linkTextField){
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y + 216.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }
}

-(IBAction)chooseType:(id)sender
{
    [self clickBackground:sender];
    [self.view addSubview:keyboardPickerToolbar];
    
    _typeLabel.backgroundColor = [UIColor clearColor];
    pickerView.hidden = NO;

    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 265, 320, 250)];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;    

    typeArray = [[NSArray alloc]initWithObjects:LocalizedString(@"Building committee"), LocalizedString(@"Mothers and children"), LocalizedString(@"Stuff exchange"), LocalizedString(@"Gardens and School"), LocalizedString(@"Sport"), LocalizedString(@"Babysitter"), LocalizedString(@"Animals"), LocalizedString(@"Hobbies"), LocalizedString(@"Business"), LocalizedString(@"The golden Age"),LocalizedString(@"Youth Movements"), LocalizedString(@"Students"), LocalizedString(@"Synagogue"), LocalizedString(@"Church"), LocalizedString(@"Mosque"), LocalizedString(@"Music"), LocalizedString(@"Restaurant"), LocalizedString(@"Cafes"), LocalizedString(@"Pub"), LocalizedString(@"Other"), nil];
    
    [self.view addSubview:pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [typeArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [typeArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _typeLabel.text = [typeArray objectAtIndex:row];
    _numberTypeLabel.text = IntToString(row+1);
}

@end
