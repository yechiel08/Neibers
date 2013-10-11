//
//  MyCommunitiesViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 26/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SenderBrain.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class RevealController;

@interface NewCommunitiesViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSData *imageData;
    CLLocationManager *locationManager;
    UIToolbar *keyboardPickerToolbar;
    UIPickerView *pickerView;
    NSArray *typeArray;
    NSString *latAddress, *lonAddress;
}

@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *communityPicture;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet GradientButton *okButton;
@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UILabel *pictureLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeOfCommunityLabel;
@property (strong, nonatomic) IBOutlet UILabel *communityName;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *descripitionCommunityLabel;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *useMyLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *openCommunity;
@property (strong, nonatomic) IBOutlet UILabel *closeCommunityLabel;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet UITextField *communityNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *descripitionTextField;
@property (strong, nonatomic) IBOutlet UITextField *linkTextField;
@property (assign, nonatomic) BOOL isFirst;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UIControl *control;
@property (strong, nonatomic) IBOutlet UILabel *numberTypeLabel;

//- (IBAction)clickBackground:(id)sender;
- (IBAction)addPhoto:(id)sender;
- (IBAction)okButtonPress:(id)sender;
- (IBAction)myAddressButtonPress:(id)sender;
- (IBAction)openCloseCommunity:(UIButton *)sender;
- (IBAction)clickBackground:(id)sender;
- (IBAction)backPress:(id)sender;
- (IBAction)skipButtonPress:(id)sender;
- (IBAction)chooseType:(id)sender;

@end
