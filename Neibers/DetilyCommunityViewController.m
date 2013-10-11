//
//  DetilyCommunityViewController.m
//  Neibers
//
//  Created by Yechiel Amar on 30/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import "DetilyCommunityViewController.h"

@interface DetilyCommunityViewController ()

@end

@implementation DetilyCommunityViewController

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
    self.headerLabel.text = _deteilCommunity.title;
    _profileWebImage.image = [UIImage imageNamed:@"icn_people"];
    NSString *imathPath = [NSString stringWithFormat:@"%@%@",NEIBERS_SERVER_URL,_deteilCommunity.imageFile];
    if (!StringIsNilOrEmpty(imathPath)) {
        NSURL *animationUrl = [NSURL URLWithString:imathPath];
        if (!StringIsNilOrEmpty(animationUrl.pathExtension)) {
            _profileWebImage.image = nil;
            [_profileWebImage loadFromURL:animationUrl];
        }
    }
    self.addressTextView.text = _deteilCommunity.subtitle;
    self.numberOfFriendsLabel.text = [NSString stringWithFormat:@"%@ %@",_deteilCommunity.numberFriends,LocalizedString(@"Members")];
    if ([_deteilCommunity.openClose isEqualToString:@"1"]) {
        self.openCloseLabel.text = LocalizedString(@"Open Community");
    } else {
        self.openCloseLabel.text = LocalizedString(@"Closed Community");
    }
    self.destrbtionLabel.text = _deteilCommunity.description;
    self.linkTextView.text = _deteilCommunity.link;

    _rateViewStar.backgroundColor = [UIColor clearColor];
    _rateViewStar.notSelectedImage = [UIImage imageNamed:@"icn_star"];
    //    self.rateView.halfSelectedImage = [UIImage imageNamed:@"kermit_half.png"];
    _rateViewStar.fullSelectedImage = [UIImage imageNamed:@"icn_star_full"];
    _rateViewStar.rating = 5;
    _rateViewStar.editable = YES;
    _rateViewStar.maxRating = 5;
    _rateViewStar.delegate = self;
//    numberRateing = @"5";
    
    [[_joiningRequest layer] insertSublayer:[appDelegate setupGradientButton:_joiningRequest gradientType:@"high"] atIndex:0];
    [[_joiningRequest layer] insertSublayer:[appDelegate setupGradientButton:_joiningRequest gradientType:@"normal"] atIndex:1];
    //    [self.navigationController setNavigationBarHidden:TRUE];
    [self.joiningRequest setTitle:LocalizedString(@"Joining request") forState:UIControlStateNormal];

    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateNormal];
    [self.backButton setTitle:LocalizedString(@"Back") forState:UIControlStateHighlighted];
    self.nameLabel.text = LocalizedString(@"For identification fill out your full name");
    
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
    if ([_deteilCommunity.numberType isEqualToString:@"1"]) {
        iconFilename = @"Home_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"2"]){
        iconFilename = @"Mother_children_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"3"]){
        iconFilename = @"Hands_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"4"]){
        iconFilename = @"School_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"5"]){
        iconFilename = @"Sport_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"6"]){
        iconFilename = @"Girl_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"7"]){
        iconFilename = @"Animals_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"8"]){
        iconFilename = @"Road_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"9"]){
        iconFilename = @"Industry_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"10"]){
        iconFilename = @"Hammer_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"11"]){
        iconFilename = @"Tie_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"12"]){
        iconFilename = @"University_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"13"]){
        iconFilename = @"Synagogue_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"14"]){
        iconFilename = @"Church_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"15"]){
        iconFilename = @"Mosque_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"16"]){
        iconFilename = @"Music_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"17"]){
        iconFilename = @"Restaurant_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"18"]){
        iconFilename = @"Cafe_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"19"]){
        iconFilename = @"Pub_on-1";
    } else if ([_deteilCommunity.numberType isEqualToString:@"20"]){
        iconFilename = @"Star_on-1";
    }
    UIImage *pinImage = [UIImage imageNamed:iconFilename];
    _typeImage.image = pinImage;
}

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    NSLog(@"Rating: %f", rating);
//    int rateInt = rating;
//    numberRateing = IntToString(rateInt);
}

- (void)viewDidUnload {
    [self setDeteilCommunity:nil];
    [self setHeaderLabel:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
}

- (IBAction)backPress:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)clickBackground:(id)sender
{
    [_nameTextField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if (textField == _nameTextField) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y - 140.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameTextField) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        _control.frame = CGRectMake(_control.frame.origin.x, (_control.frame.origin.y + 140.0), _control.frame.size.width, _control.frame.size.height);
        
        [UIView commitAnimations];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
