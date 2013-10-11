//
//  StartViewController.m
//  Movon
//
//  Created by Yechiel Amar on 06/05/13.
//  Copyright (c) 2013 Yechiel  Amar. All rights reserved.
//

#import "StartViewController.h"
#import "RearViewController.h"
#import "RevealController.h"

@interface StartViewController ()

@end

@implementation StartViewController

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
        
//    CAGradientLayer *buttonUserNameGradient = [CAGradientLayer layer];
//    buttonUserNameGradient.frame = self.userNameButton.bounds;
//    buttonUserNameGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"#ff8752" alpha:1.0] CGColor], (id)[[UIColor colorWithHex:@"#ee4d06" alpha:1.0] CGColor], nil];
//    [self.userNameButton.layer insertSublayer:buttonUserNameGradient atIndex:0];
//    
//    CAGradientLayer *buttonLoginGradient = [CAGradientLayer layer];
//    buttonLoginGradient.frame = self.loginButton.bounds;
//    buttonLoginGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithHex:@"#ff8752" alpha:1.0] CGColor], (id)[[UIColor colorWithHex:@"#ee4d06" alpha:1.0] CGColor], nil];
//    [self.loginButton.layer insertSublayer:buttonLoginGradient atIndex:0];
    
//    [appDelegate addLinearGradientToView:_facebookButton TopColor:[UIColor colorWithHex:@"#ff8752" alpha:1.0] BottomColor:[UIColor colorWithHex:@"#ee4d06" alpha:1.0]];
//    [appDelegate addLinearGradientToView:_loginButton TopColor:[UIColor colorWithHex:@"#ff8752" alpha:1.0] BottomColor:[UIColor colorWithHex:@"#ee4d06" alpha:1.0]];
//    [appDelegate addLinearGradientToView:_userNameButton TopColor:[UIColor colorWithHex:@"#ff8752" alpha:1.0] BottomColor:[UIColor colorWithHex:@"#ee4d06" alpha:1.0]];

//    [self setupColors];
    [self setupButtons];
    
    [self.facebookButton setTitle:LocalizedString(@"FaceBook") forState:UIControlStateNormal];
    [self.userNameButton setTitle:LocalizedString(@"New User") forState:UIControlStateNormal];
    [self.loginButton setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    [self.laterButton setTitle:LocalizedString(@"Later") forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.facebookButton setTitle:LocalizedString(@"FaceBook") forState:UIControlStateNormal];
    [self.userNameButton setTitle:LocalizedString(@"New User") forState:UIControlStateNormal];
    [self.loginButton setTitle:LocalizedString(@"Login") forState:UIControlStateNormal];
    [self.laterButton setTitle:LocalizedString(@"Later") forState:UIControlStateNormal];
}

-(void)setupButtons{
    
    // keep track of which buttons are which in our loop
    // to build the appropriate gradient color
    for(UIButton *bt in [[self view] subviews ]) {
        
        // tags are the index in the array of which button is which, best way to
        // integrate with interface builder
        if([bt tag] == 1){
            
            // build each gradient and plop into button, 0 is bottom/not visible, 1 is visible
            // the subclassed "highlight" method flips this order
            
            [[bt layer] insertSublayer:[appDelegate setupGradientButton:bt gradientType:@"high"] atIndex:0];
            [[bt layer] insertSublayer:[appDelegate setupGradientButton:bt gradientType:@"normal"] atIndex:1];
            
//            // build the border key, it's a bit different, just the type_border"
//            NSString *border_key=[NSString stringWithFormat:@"%@_border",bt];
//            [[bt layer] setBorderColor:[[colors objectForKey:border_key] CGColor]];
//            // note borderwidth is vital to getting color to work- I do this in subclass lyrButton
        }
    }
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
    
    
    NSData *imageData = [self repalseUrlStringToData:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=150&height=150",[arrayUser valueForKey:@"username"]]];
        
    if (imageData!=nil) {

        NSString *status = [SenderBrain UpdateNewUser:userFaceBookEmail :@"" :userFaceBookName :imageData :0];
        
        if ([status isEqualToString:@"AccessToken"]) {
            
            [[NSUserDefaults standardUserDefaults] setValue:@"SignIn" forKey:@"StatusSign"];
            [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"Later"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            MapViewController *frontViewController = [[MapViewController alloc] init];
            RearViewController *rearViewController = [[RearViewController alloc] init];
            
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
            
            RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
            self.viewController = revealController;
            
            [self.navigationController pushViewController:revealController animated:NO];
        }
        else if ([status isEqualToString:@"UserName Exists"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"eMail" message:@"User name already exists Please replace username or do login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }else {
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
        data = UIImageJPEGRepresentation(image, 90);
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

- (IBAction)loginNewUser:(id)sender {
    NewUserViewController *newLoginViewController = [[NewUserViewController alloc] init];
    [self.navigationController pushViewController:newLoginViewController animated:YES];
}

- (IBAction)laterButtonPress:(id)sender {
    
    NSMutableDictionary *userProfileDic;
    
    //found the path of DEVICE_FILE_NAME
    NSArray *pathsDevice = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDevice=[NSString stringWithFormat:@"%@/%@",[pathsDevice objectAtIndex:0],@"newUserFiles.plist"];
    
    //checking for exist of the user data as DEVICE_FILE_NAME
    if ([[NSFileManager defaultManager]fileExistsAtPath:pathDevice]){
        userProfileDic = [[NSMutableDictionary alloc] initWithContentsOfFile:pathDevice];
    }
    else {
        //        NSLog(@"no file NEW_USER_FILE_NAME");
        userProfileDic = [[NSMutableDictionary alloc] init];
    }
    
    [userProfileDic setObject:@"H7Esvgq3W8FM0jGVzJv5kzR1Liakkkcgq3W7q1O" forKey:KEY_ACCESS_TOKEN];
    [userProfileDic writeToFile:pathDevice atomically:YES];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"SignIn" forKey:@"StatusSign"];
    [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"Later"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    MapViewController *frontViewController = [[MapViewController alloc] init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:rearViewController];
    self.viewController = revealController;
    
    [self.navigationController pushViewController:revealController animated:NO];
//    MapViewController *homeViewController = [[MapViewController alloc] init];
//    [self.navigationController pushViewController:homeViewController animated:NO];
}

- (IBAction)signIn:(id)sender {
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)viewDidUnload {
    [self setFacebookButton:nil];
    [self setUserNameButton:nil];
    [self setLoginButton:nil];
    [self setLaterButton:nil];
    [super viewDidUnload];
}
@end
