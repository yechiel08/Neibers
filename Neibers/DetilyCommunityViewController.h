//
//  DetilyCommunityViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 30/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "WebImageView.h"
#import "DomainObjects.h"
#import "AppDelegate.h"
#import "SenderBrain.h"
#import "RateView.h"
#import <QuartzCore/QuartzCore.h>

@interface DetilyCommunityViewController : UIViewController <RateViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Article *deteilCommunity;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *addressTextView;
@property (strong, nonatomic) IBOutlet UILabel *numberOfFriendsLabel;
@property (strong, nonatomic) IBOutlet UILabel *openCloseLabel;
@property (strong, nonatomic) IBOutlet UILabel *destrbtionLabel;
@property (strong, nonatomic) IBOutlet UITextView *linkTextView;
@property (strong, nonatomic) IBOutlet WebImageView *profileWebImage;
@property (strong, nonatomic) IBOutlet RateView *rateViewStar;
@property (strong, nonatomic) IBOutlet GradientButton *joiningRequest;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIImageView *typeImage;
@property (strong, nonatomic) IBOutlet UIControl *control;

- (IBAction)backPress:(id)sender;
- (IBAction)clickBackground:(id)sender;

@end
