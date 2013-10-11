//
//  MapViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Article.h"
#import "DomainObjects.h"
#import "WebImageView.h"
//#import "CalloutMapAnnotation.h"
//#import "BasicMapAnnotation.h"

#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "CustomPlacemark.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MBProgressHUD.h"
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,UISearchBarDelegate, BSForwardGeocoderDelegate, MFMailComposeViewControllerDelegate>{
    NSMutableArray *freind;
    CLLocationCoordinate2D zoomLocation;
    MKCoordinateSpan span;
    
    NSMutableArray *articles;
    NSArray *userArray;
    NSString *pageStringNumber;
    NSArray *moreArray;
    NSString *srcTag;
    
    MKMapView *_mapView;
//	CalloutMapAnnotation *_calloutAnnotation;
	MKAnnotationView *_selectedAnnotationView;
//	BasicMapAnnotation *_customAnnotation;
//	BasicMapAnnotation *_normalAnnotation;
    BSForwardGeocoder *forwardGeocoder;
    NSMutableArray *searchAnnotations;
}
@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;

@property (nonatomic, retain) Article *article, *houseAnnotation;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIButton *shereButton;
@property (strong, nonatomic) IBOutlet UIButton *myCommunitysButton;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (strong, nonatomic) IBOutlet UIButton *twitterButton;

- (IBAction)openCommunity:(id)sender;
-(IBAction)showMyLocation:(id)sender;
-(IBAction)zoomPlus:(id)sender;
-(IBAction)zoomMinus:(id)sender;
- (IBAction)searcButtonPress:(id)sender;
- (IBAction)shareButtonPress:(UIButton *)sender;
- (IBAction)twitterButton:(id)sender;
- (IBAction)faceBookButton:(id)sender;
- (IBAction)emailButton:(id)sender;
- (IBAction)myCommunityButtonPress:(id)sender;

@end
