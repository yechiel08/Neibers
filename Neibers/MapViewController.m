//
//  MapViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 17/07/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "SenderBrain.h"

#import "Extentions.h"
//#import "MapPinView.h"
//#import "BasicMapAnnotation.h"
//#import "CalloutMapAnnotation.h"
//#import "CalloutMapAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MyCommunityViewController.h"
#import "DetilyCommunityViewController.h"
#import "NewCommunitiesViewController.h"

//tag for subview - make it unique
#define STATUS_VIEW_TAG 9998

@interface MapViewController ()

//@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
//@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;
//@property (nonatomic, retain) BasicMapAnnotation *normalAnnotation;

@end

@implementation MapViewController
@synthesize goButton;
@synthesize mapView = _mapView;
@synthesize selectedAnnotationView = _selectedAnnotationView;
@synthesize forwardGeocoder = _forwardGeocoder;

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
    
    if ([self.navigationController.parentViewController respondsToSelector:@selector(revealGesture:)] && [self.navigationController.parentViewController respondsToSelector:@selector(revealToggle:)])
	{
		UIPanGestureRecognizer *navigationBarPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navigationController.parentViewController action:@selector(revealGesture:)];
        
        [_menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addGestureRecognizer:navigationBarPanGestureRecognizer];
	}
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 568){
        _myCommunitysButton.frame = CGRectMake(0, 415 + 88, _myCommunitysButton.bounds.size.width, _myCommunitysButton.bounds.size.height);
        goButton.frame = CGRectMake(0, 415 + 88, goButton.bounds.size.width, goButton.bounds.size.height);
    }
    //    self.mapView.delegate = self;
    //
    //	self.customAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:38.6335 andLongitude:-90.2045];
    //
    //	[self.mapView addAnnotation:self.customAnnotation];
    //
    //	self.normalAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:38 andLongitude:-90.2045];
    //	self.normalAnnotation.title = @"                                                         ";
    //	[self.mapView addAnnotation:self.normalAnnotation];
    //
    //	CLLocationCoordinate2D coordinate = {38.315, -90.2045};
    //	[self.mapView setRegion:MKCoordinateRegionMake(coordinate,
    //												   MKCoordinateSpanMake(1, 1))];
    _mapView.delegate = self;
    
    MKCoordinateRegion region;
    span.latitudeDelta = 0.00900901;
    span.longitudeDelta = 0.01137387;
    
    CLLocationManager *location = [[CLLocationManager alloc]init];
    [location startUpdatingLocation];
    
    zoomLocation.latitude = location.location.coordinate.latitude;
    zoomLocation.longitude = location.location.coordinate.longitude;
    [location stopUpdatingLocation];
    
    region.span = span;
    region.center = zoomLocation;
    
    [_mapView setRegion:region animated:NO];
    //    [mapView addAnnotations:freind];
    _mapView.showsUserLocation=TRUE;
    searchAnnotations = [[NSMutableArray alloc]init];
    //    mapView.mapType=MKMapTypeHybrid;
    [self.shereButton setTitle:LocalizedString(@"Shere") forState:UIControlStateNormal];
    [self.myCommunitysButton setTitle:LocalizedString(@"My Communities") forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
    
    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    [appDelegate openSessionWithAllowLoginUI:NO];
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    } else {
        action();
    }
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        
    } else {
        
    }
}

- (void)showFeedDialog {
    //    // Post a status update to the user's feed via the Graph API, and display an alert view
    //    // with the results or an error.
    //
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    //
    //    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    //    // The first method tries to share via the Facebook app. This allows sharing without
    //    // the user having to authorize your app, and is available as long as the user has the
    //    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    //    // Facebook app.
    //    // The second method tries to share via Facebook's iOS6 integration, which also
    //    // allows sharing without the user having to authorize your app, and is available as
    //    // long as the user has linked their Facebook account with iOS6. This publish will
    //    // result in a popup iOS6 dialog.
    //    // The third method tries to share via a Graph API request. This does require the user
    //    // to authorize your app. They must also grant your app publish permissions. This
    //    // allows the app to publish without any user interaction.
    //
    //    // If it is available, we will first try to post using the share dialog in the Facebook app
    //    FBAppCall *appCall = [FBDialogs presentShareDialogWithLink:urlToShare
    //                                                          name:@"Hello Facebook"
    //                                                       caption:nil
    //                                                   description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
    //                                                       picture:nil
    //                                                   clientState:nil
    //                                                       handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
    //                                                           if (error) {
    //                                                               NSLog(@"Error: %@", error.description);
    //                                                           } else {
    //                                                               NSLog(@"Success!");
    //                                                           }
    //                                                       }];
    //
    //    if (!appCall) {
    //        // Next try to post using Facebook's iOS6 integration
    //        BOOL displayedNativeDialog = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
    //                                                                              initialText:nil
    //                                                                                    image:nil
    //                                                                                      url:urlToShare
    //                                                                                  handler:nil];
    //
    //        if (!displayedNativeDialog) {
    //            // Lastly, fall back on a request for permissions and a direct post using the Graph API
    //            [self performPublishAction:^{
    //                NSString *message = [NSString stringWithFormat:@"Updating status for Yechiel at %@", [NSDate date]];
    //
    //                [FBRequestConnection startForPostStatusUpdate:message
    //                                            completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
    //
    //                                                [self showAlert:message result:result error:error];
    ////                                                self.buttonPostStatus.enabled = YES;
    //                                            }];
    //
    ////                self.buttonPostStatus.enabled = NO;
    //            }];
    //        }
    //    }
    
    // Put together the dialog parameters
    
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Neibers", @"name",
     @"I'm using Neibers to Chat. You should use it too! Download it NOW for Free! \n https://itunes.apple.com/us/app/neibers/id668611158?ls=1&mt=8", @"caption",
     @"", @"description",
     @"https://itunes.apple.com/us/app/neibers/id668611158?ls=1&mt=8", @"link",
     @"http://neibers.org/images/Default.png", @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         
         if (error) {
             // Case A: Error launching the dialog or publishing story.
             NSLog(@"Error publishing story.");
             // Show the result in an alert
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FaceBook" message:@"Messege not sent \n Try Again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             alert.tag = 10;
             [alert show];
             
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // Case B: User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Case C: Dialog shown and the user clicks Cancel or Share
                 
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *postID = [urlParams valueForKey:@"post_id"];
                     NSLog(@"Posted story, id: %@", postID);
                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"FaceBook" message:@"Posted on FaceBook" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     alert.tag = 10;
                     [alert show];
                 }
             }
         }
     }];
}

/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
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
                NSLog(@"User session found");
                [self showFeedDialog];
                // Set up the view controller that will show friend information
                //                ShareViewController *viewController =
                //                [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
                //                NSString *linkString = @"http://movon.co/";
                //                viewController.stringLink = linkString;
                //                viewController.imageSend = @"http://movon.co/images/icon160.png";
                //                // Present view controller modally.
                //                if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
                //                    // iOS 5+
                //                    [self presentViewController:viewController animated:YES completion:nil];
                //                } else {
                //                    [self presentModalViewController:viewController animated:YES];
                //                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        //        appDelegate.isFacebookOpen = YES;
        //        [appDelegate viewIfNoConnctionWithFaceBook];
        //        UIAlertView *alertView = [[UIAlertView alloc]
        //                                  initWithTitle:@"Error"
        //                                  message:error.localizedDescription
        //                                  delegate:nil
        //                                  cancelButtonTitle:@"OK"
        //                                  otherButtonTitles:nil];
        //        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"basic_info", @"email", @"user_photos",
                            nil];
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

- (IBAction)faceBookButton:(id)sender {
    [self openSessionWithAllowLoginUI:YES];
}

- (void)publishStory
{
    //    NSArray *arrayUser = [SenderBrain getUserFaceBook];
    //    [SenderBrain sendPublishFeed:[arrayUser valueForKey:@"username"]];
}
- (IBAction)twitterButton:(id)sender {
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    [tweetViewController setInitialText:@"I'm using Neibers to Chat. You should use it too! Download it NOW for Free! \n https://itunes.apple.com/us/app/neibers/id668611158?ls=1&mt=8"];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        NSLog(@"%d",result);
        
        NSString *output;
        
        switch (result) {
                
            case TWTweetComposeViewControllerResultCancelled:
                
                // The cancel button was tapped.
                
                output = LocalizedString(@"Tweet cancelled.");
                
                break;
                
            case TWTweetComposeViewControllerResultDone:
                
                // The tweet was sent.
                
                output = LocalizedString(@"Tweet done.");
                
                break;
                
            default:
                
                break;
                
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Twitter"
                                    message:output
                                   delegate:self
                          cancelButtonTitle:LocalizedString(@"OK!")
                          otherButtonTitles:nil]
         show];
        
        
        //        [self performSelectorOnMainThread:@selector(displayText:) withObject:output waitUntilDone:NO];
        // Dismiss view controller based on supported methods
        //        if ([self respondsToSelector:@selector(presentingViewController)]) {
        //            // iOS 5+ support
        //            [[self presentingViewController] dismissModalViewControllerAnimated:YES];
        //        } else {
        //            [[self parentViewController] dismissModalViewControllerAnimated:YES];
        //        }
        [self dismissModalViewControllerAnimated:YES];
        
    }];
    // Present view controller modally.
    //    if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
    //        // iOS 5+
    //        [self presentViewController:tweetViewController animated:YES completion:nil];
    //    } else {
    //        [self presentModalViewController:tweetViewController animated:YES];
    //    }
    
    [self presentModalViewController:tweetViewController animated:YES];
    //    [self viewSettingExit];
}

- (void)canTweetStatus {
    
    if ([TWTweetComposeViewController canSendTweet]) {
        
        _twitterButton.enabled = YES;
        
        _twitterButton.alpha = 1.0f;
        
        
    } else {
        
        _twitterButton.enabled = NO;
        
        _twitterButton.alpha = 0.5f;
        
    }
}

- (IBAction)emailButton:(id)sender {
    
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Neibers"];
        [mailer setMessageBody:@"I'm using Neibers to Chat. You should use it too! Download it NOW for Free! \n https://itunes.apple.com/us/app/neibers/id668611158?ls=1&mt=8" isHTML:YES];
        NSArray *to = [NSArray arrayWithObject:@"suport@neibers.org"];
        
        [mailer setToRecipients:to];
        //        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        //            // iOS 5+
        //            [self presentViewController:mailer animated:YES completion:nil];
        //        } else {
        //            [self presentModalViewController:mailer animated:YES];
        //        }
        [self presentModalViewController:mailer animated:YES];
    }
    //    [self viewSettingExit];
}

- (IBAction)myCommunityButtonPress:(id)sender {
    MyCommunityViewController *newLoginViewController = [[MyCommunityViewController alloc] init];
    newLoginViewController.fromMap = YES;
    [self.navigationController pushViewController:newLoginViewController animated:YES];

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	// BSForwardGeocoder custom placemarks
	if([annotation isKindOfClass:[CustomPlacemark class]])
	{
		MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPlaceMarkIdentifier"];
		newAnnotation.pinColor = MKPinAnnotationColorGreen;
		newAnnotation.animatesDrop = YES;
		newAnnotation.canShowCallout = YES;
		newAnnotation.enabled = YES;
		
		
		NSLog(@"Created annotation at: %f", ((CustomPlacemark*)annotation).coordinate.latitude);
				
		return newAnnotation;
	}else {
        if (annotation != self.mapView.userLocation) {
            _houseAnnotation = (Article *)annotation;
            
            NSString *myIdentifier = @"BusinessIcon";
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
            
            NSString *iconFilename;
//          1   "Building committee" = "ועד בית";
//          2   "Mothers and children" = "אימהות וילדים";
//          3   "Stuff exchange" = "קח תן";
//          4   "Gardens and School" = "גנים ובי\"ס";
//          5   "Sport" = "ספורט";
//          6   "Babysitter" = "בייביסיטר";
//          7   "Animals" = "בעלי חיים";
//          8   "Hobbies" = "תחביבים";
//          9   "Business" = "עסקים";
//          10  "The golden Age" = "גיל הזהב";
//          11  "Youth Movements" = "תנועות נוער";
//          12  "Students" = "סטודנטים";
//          13  "Synagogue" = "בית כנסת";
//          14  "Other" = "אחר";
//          15  "Church" = "כנסיה";
//          16  "Mosque" = "מסגד";
//          17  "Music" = "מוסיקה";
//          18  "Restaurant" = "מסעדה";
//          19  "Cafes" = "בתי קפה";
//          20  "Pub" = "פאב";            
            if ([_houseAnnotation.numberType isEqualToString:@"1"]) {
                iconFilename = @"Home_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"2"]){
                iconFilename = @"Mother_children_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"3"]){
                iconFilename = @"Hands_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"4"]){
                iconFilename = @"School_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"5"]){
                iconFilename = @"Sport_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"6"]){
                iconFilename = @"Girl_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"7"]){
                iconFilename = @"Animals_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"8"]){
                iconFilename = @"Road_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"9"]){
                iconFilename = @"Industry_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"10"]){
                iconFilename = @"Hammer_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"11"]){
                iconFilename = @"Tie_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"12"]){
                iconFilename = @"University_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"13"]){
                iconFilename = @"Synagogue_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"14"]){
                iconFilename = @"Church_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"15"]){
                iconFilename = @"Mosque_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"16"]){
                iconFilename = @"Music_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"17"]){
                iconFilename = @"Restaurant_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"18"]){
                iconFilename = @"Cafe_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"19"]){
                iconFilename = @"Pub_on";
            } else if ([_houseAnnotation.numberType isEqualToString:@"20"]){
                iconFilename = @"Star_on";
            }
            UIImage *pinImage = [UIImage imageNamed:iconFilename];
            [customAnnotationView setImage:pinImage];
            customAnnotationView.canShowCallout = YES;
            customAnnotationView.centerOffset = CGPointMake(0,-32);
//            customAnnotationView.calloutOffset = CGPointMake(-8,0);
            NSLog(@"%@",_houseAnnotation.imageFile);
            //        NSData* data=[_houseAnnotation.userImage dataUsingEncoding:NSUTF8StringEncoding];
            //        UIImage *image = [self repalseUrlStringToImage:_houseAnnotation.userImage];
            //        UIImageView *leftIcon = [[UIImageView alloc] initWithImage:image];
            NSString *imathPath = [NSString stringWithFormat:@"%@%@",NEIBERS_SERVER_URL,_houseAnnotation.imageFile];
            WebImageView *leftIcon = [[WebImageView alloc]init];
            leftIcon.image = [UIImage imageNamed:@"PhotoMassegePage"];
            if (!StringIsNilOrEmpty(imathPath)) {
                NSURL *animationUrl = [NSURL URLWithString:imathPath];
                if (!StringIsNilOrEmpty(animationUrl.pathExtension)) {
                    leftIcon.image = nil;
                    [leftIcon loadFromURL:animationUrl];
                }
            }
            
            customAnnotationView.leftCalloutAccessoryView = leftIcon;
            customAnnotationView.leftCalloutAccessoryView.size = CGSizeMake(30, 30);
            //        customAnnotationView.leftCalloutAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(annotationViewClick)
                  forControlEvents:UIControlEventTouchUpInside];
            customAnnotationView.rightCalloutAccessoryView = rightButton;
            return customAnnotationView;
        } else {
            return nil;
        }
    }
	
    
    return nil;
}

///*
// DECIDED NOT TO USE THIS BECAUSE IT IS ONLY SUPPORTED ON IOS 4.0 AND UP
// - (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
// self.selectedPOI = (POI*)view.annotation;
// NSLog(@"selected %@ \n %@ \n %@ \n %@ \n %@",selectedPOI.name_org, selectedPOI.streetHouseRoom,selectedPOI.countryCity, selectedPOI.telephone,selectedPOI.mobile);
// }
// */
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
//	self.selectedPOI = (POI*)view.annotation;
//	self.detailsController.selectedPOI = self.selectedPOI;
//	[self presentModalViewController:self.detailsController animated:YES];
//}
//
//- (void)showDetails {
//	
//}


//-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    if (annotation != self.mapView.userLocation) {
////        _houseAnnotation = (Article *)annotation;
//        
//        NSString *myIdentifier = @"BusinessIcon";
//        MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
//        
////        NSString *iconFilename = @"";
////        if ([_houseAnnotation.businessIcon isEqualToString:@"true"]) {
////            iconFilename = @"GreenMapPin";
////        } else if ([_houseAnnotation.businessIcon isEqualToString:@"false"]){
////            iconFilename = @"BlueMapPin";
////        }
////        UIImage *pinImage = [UIImage imageNamed:iconFilename];
////        [customAnnotationView setImage:pinImage];
////        customAnnotationView.canShowCallout = YES;
////        //        customAnnotationView.centerOffset = CGPointMake(0,-15);
////        //        customAnnotationView.calloutOffset = CGPointMake(-8,0);
////        NSLog(@"%@",_houseAnnotation.userImage);
////        //        NSData* data=[_houseAnnotation.userImage dataUsingEncoding:NSUTF8StringEncoding];
////        //        UIImage *image = [self repalseUrlStringToImage:_houseAnnotation.userImage];
////        //        UIImageView *leftIcon = [[UIImageView alloc] initWithImage:image];
////        
////        WebImageView *leftIcon = [[WebImageView alloc]init];
////        leftIcon.image = [UIImage imageNamed:@"PhotoMassegePage"];
////        if (!StringIsNilOrEmpty(_houseAnnotation.userImage)) {
////            NSURL *animationUrl = [NSURL URLWithString:_houseAnnotation.userImage];
////            if (!StringIsNilOrEmpty(animationUrl.pathExtension)) {
////                leftIcon.image = nil;
////                [leftIcon loadFromURL:animationUrl];
////            }
////        }
//        
////        customAnnotationView.leftCalloutAccessoryView = leftIcon;
//        customAnnotationView.leftCalloutAccessoryView.size = CGSizeMake(30, 30);
//        //        customAnnotationView.leftCalloutAccessoryView.contentMode = UIViewContentModeScaleAspectFit;
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self
//                        action:@selector(annotationViewClick)
//              forControlEvents:UIControlEventTouchUpInside];
//        customAnnotationView.rightCalloutAccessoryView = rightButton;
//        return customAnnotationView;
//    } else {
//        return nil;
//    }
//}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
//    _houseAnnotation = (Article *)view.annotation;
    //    NSLog(@"%@",_houseAnnotation.userImage);
    //    WebImageView *leftIcon = [[WebImageView alloc]init];
    //    leftIcon.image = [UIImage imageNamed:@"PhotoMassegePage"];
    //    if (!StringIsNilOrEmpty(_houseAnnotation.userImage)) {
    //        NSURL *animationUrl = [NSURL URLWithString:_houseAnnotation.userImage];
    //        if (!StringIsNilOrEmpty(animationUrl.pathExtension)) {
    //            leftIcon.image = nil;
    //            [leftIcon loadFromURL:animationUrl];
    //        }
    //    }
    ////    UIImage *image = [self repalseUrlStringToImage:_houseAnnotation.userImage];
    ////    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:image];
    //
    ////    UIImage *image = [UIImage imagesMapViewController:self thumbnailForAnnotation:_houseAnnotation];
    //    NSLog(@"Image was: %@", [(UIImageView *)view.leftCalloutAccessoryView image]);
    //    NSLog(@"Image received: %@", leftIcon.image);
    //    [(UIImageView *)view.leftCalloutAccessoryView setImage:leftIcon.image];
    //    NSLog(@"Image became: %@", [(UIImageView *)view.leftCalloutAccessoryView image]);
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    _houseAnnotation = (Article *)view.annotation;
    DetilyCommunityViewController *detilyCommunityViewController = [[DetilyCommunityViewController alloc]init];
    detilyCommunityViewController.deteilCommunity = _houseAnnotation;
//    DetilyCommunityViewController.userIdPress = _houseAnnotation.userID;
//    DetilyCommunityViewController.pageId = _houseAnnotation.pageID;
    [self.navigationController pushViewController:detilyCommunityViewController animated:YES];
}

-(void)annotationViewClick
{
    
}

- (IBAction)openCommunity:(id)sender {
    NewCommunitiesViewController *newCommunitiesViewController = [[NewCommunitiesViewController alloc] init];
    newCommunitiesViewController.isFirst = NO;
    [self.navigationController pushViewController:newCommunitiesViewController animated:NO];
}

-(IBAction)showMyLocation:(id)sender
{
    //    MenuViewController *topbar = [[MenuViewController alloc]init];
    //    [topbar loadView];
    //    [self.navigationController pushViewController:topbar animated:YES];
    MKCoordinateRegion region;
    
    CLLocationManager *location = [[CLLocationManager alloc]init];
    [location startUpdatingLocation];
    
    zoomLocation.latitude = location.location.coordinate.latitude;
    zoomLocation.longitude = location.location.coordinate.longitude;
    [location stopUpdatingLocation];
    
    region.span = span;
    region.center = zoomLocation;
    
    [_mapView setRegion:region animated:TRUE];
}

-(IBAction)zoomPlus:(id)sender{
    if (span.latitudeDelta <= 0.0045045){
        
    }
    else{
        if (span.latitudeDelta >= 0.04504504) {
            span.latitudeDelta = 0.02702703;
            span.longitudeDelta = 0.03412162;
        } else if ((span.latitudeDelta >= 0.02702703) && (span.latitudeDelta < 0.04504504)){
            span.latitudeDelta = 0.00900901;
            span.longitudeDelta = 0.01137387;
        }else if ((span.latitudeDelta >= 0.00900901) && (span.longitudeDelta < 0.02702703)) {
            span.latitudeDelta = 0.0045045;
            span.longitudeDelta = 0.00568694;
        }
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = zoomLocation;
        
        [_mapView setRegion:region animated:TRUE];
    }
}

-(IBAction)zoomMinus:(id)sender{
    if (span.latitudeDelta >= 0.04504504){
        
    }
    else{
        if (span.latitudeDelta <= 0.0045045) {
            span.latitudeDelta = 0.00900901;
            span.longitudeDelta = 0.01137387;
        }else if ((span.latitudeDelta <= 0.00900901) && (span.longitudeDelta > 0.0045045)) {
            span.latitudeDelta = 0.02702703;
            span.longitudeDelta = 0.03412162;
        } else if ((span.latitudeDelta <= 0.02702703) && (span.longitudeDelta > 0.00900901)) {
            span.latitudeDelta = 0.04504504;
            span.longitudeDelta = 0.05686937;
        }
        
        MKCoordinateRegion region;
        region.span = span;
        region.center = zoomLocation;
        
        [_mapView setRegion:region animated:TRUE];
    }
}

- (IBAction)searcButtonPress:(id)sender {
//    [_searchTextField becomeFirstResponder];
    NSLog(@"Searching for: %@", _searchTextField.text);
	if(forwardGeocoder == nil)
	{
		forwardGeocoder = [[BSForwardGeocoder alloc] initWithDelegate:self];
	}
	
	// Forward geocode!
	[forwardGeocoder findLocation:_searchTextField.text];
}

- (IBAction)shareButtonPress:(UIButton *)sender {
    CGRect rect;
    if (sender.selected) {
        sender.selected = NO;
        rect = CGRectMake(262, -130, 58, 130);
    } else {
        sender.selected = YES;
        rect = CGRectMake(262, 45, 58, 130);
    }
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.shareView.frame = rect;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}

- (void)mapView:(MKMapView *)mapViews regionWillChangeAnimated:(BOOL)animated{
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    zoomLocation = [mapView centerCoordinate];
    double centerLat = mapView.region.center.latitude;
	double centerLong = mapView.region.center.longitude;
	double a = mapView.region.span.latitudeDelta/2;
	double b = mapView.region.span.longitudeDelta/2;
	double northEastLat = centerLat + a;
	double southWestLat = centerLat - a;
	double northEastLong = centerLong + b;
	double southWestLong = centerLong - b;
	
	NSLog(@"southWestLat = %f,southWestLong = %f,northEastLat = %f,NorthEastLong = %f",southWestLat,southWestLong,northEastLat,northEastLong);
}

-(IBAction)backPressed:(id)sender
{
    if ([self.navigationController popViewControllerAnimated:TRUE])
	{
        [self.navigationController popViewControllerAnimated:TRUE];
	}else {
        [_menuButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)sendLink{
    userArray = [SenderBrain getMapCommunity];
    
    NSLog(@"userArray count: %d",[userArray count]);
    
    [self performSelectorOnMainThread:@selector(loadArticle) withObject:nil waitUntilDone:YES];
}


-(void)loadFirstArticle
{
    [self loadArticle];
}

-(void)loadArticle
{
    articles = [[NSMutableArray alloc] init];
    for (int i =0; i<[userArray  count]; i++)
    {
        CLLocationCoordinate2D location;
        location.latitude = [[[userArray objectAtIndex:i]valueForKey:@"lat"] floatValue];
        location.longitude = [[[userArray objectAtIndex:i]valueForKey:@"lon"] floatValue];
        _article = [[Article alloc] initWithID:[[userArray objectAtIndex:i]valueForKey:@"ID"] accessToken:[[userArray objectAtIndex:i]valueForKey:@"accessToken"] imageFile:[[userArray objectAtIndex:i]valueForKey:@"imageFile"] type:[[userArray objectAtIndex:i]valueForKey:@"type"] numberType:[[userArray objectAtIndex:i]valueForKey:@"numberType"] title:[[userArray objectAtIndex:i]valueForKey:@"name"] subtitle:[[userArray objectAtIndex:i]valueForKey:@"address"] description:[[userArray objectAtIndex:i]valueForKey:@"description"] link:[[userArray objectAtIndex:i]valueForKey:@"link"] openClose:[[userArray objectAtIndex:i]valueForKey:@"openCloseCommunity"] numberFriends:[[userArray objectAtIndex:i]valueForKey:@"numberFriends"] longitude:location.latitude latitude:location.longitude coordinate:location];
        
        [articles addObject:_article];
    }
    NSLog(@"search list: %d", [articles count]);
    [_mapView addAnnotations:articles];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"%@, %@",appDelegate.lat, appDelegate.longt);
    
    [self performSelectorInBackground:@selector(sendLink) withObject:nil];
}

- (void)forwardGeocoderError:(NSString *)errorMessage
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
													message:@"The SEARCH function requires an active internet connection"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles: nil];
	[alert show];	
}

-(void)forwardGeocoderFoundLocation
{
	if(forwardGeocoder.status == G_GEO_SUCCESS)
	{
		
		// Remove previous search result annotations
		[_mapView removeAnnotations:searchAnnotations];
		[searchAnnotations removeAllObjects];
		
//        for (int i = 0; i < forwardGeocoder.results.count; i++) {
            BSKmlResult *place = [forwardGeocoder.results objectAtIndex:0];
            
            // Add a placemark on the map
            CustomPlacemark *placemark = [[CustomPlacemark alloc] initWithRegion:place.coordinateRegion];
            
            placemark.address = @" ";
            
            
            NSMutableString *address = [NSMutableString stringWithCapacity:1];
            for (BSAddressComponent *comp in place.addressComponents) {
                [address appendString:comp.longName];
                [address appendString:@" "];
                
            }
            
            placemark.message = address;
            [_mapView addAnnotation:placemark];
            [searchAnnotations addObject:placemark];
//            if (i==0) 
                // Zoom into the location
                [_mapView setRegion:place.coordinateRegion animated:TRUE];
//        }
		
		// Dismiss the keyboard
		[_searchTextField resignFirstResponder];
	}
	else {
		NSString *message = @"";
		
		switch (forwardGeocoder.status) {
			case G_GEO_BAD_KEY:
				message = @"The API key is invalid.";
				break;
				
			case G_GEO_UNKNOWN_ADDRESS:
				message = [NSString stringWithFormat:@"Could not find %@", forwardGeocoder.searchQuery];
				break;
				
			case G_GEO_TOO_MANY_QUERIES:
				message = @"Too many queries has been made for this API key.";
				break;
				
			case G_GEO_SERVER_ERROR:
				message = @"Server error, please try again.";
				break;
				
				
			default:
				break;
		}
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
														message:message
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
		[alert show];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSearchTextField:nil];
    [self setShereButton:nil];
    [self setMyCommunitysButton:nil];
    [self setShareView:nil];
    [self setTwitterButton:nil];
    [super viewDidUnload];
}
@end
