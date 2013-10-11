/* 
 
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of Philip Kluz, 'zuui.org' nor the names of its contributors may 
 be used to endorse or promote products derived from this software 
 without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PHILIP KLUZ BE LIABLE FOR ANY DIRECT, 
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 */

#import "RearViewController.h"

#import "RevealController.h"
#import "MapViewController.h"
#import "LoginViewController.h"
#import "StartViewController.h"
#import "NewCommunitiesViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "Extentions.h"
#import "AboutViewController.h"
#import "MyCommunityViewController.h"
#import "MyMeetingsViewController.h"
#import "JoinRequestsViewController.h"

@interface RearViewController()

// Private Properties:

// Private Methods:

@end

@implementation RearViewController

@synthesize scrollView = _scrollView;

#pragma marl - UITableView Data Source
-(void)viewDidLoad
{
    [super viewDidLoad];
//    [SenderBrain loudUserProfile];
//    _control.hidden = YES;
//    _searchTextField.delegate = self;
    
    [self.navigationController setNavigationBarHidden:TRUE];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height == 568){
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
        _scrollView.frame = CGRectMake(_scrollView.bounds.origin.x, 45, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    }
    
    _scrollView.contentSize = CGSizeMake(0,425);
    
    self.headerLabel.text = LocalizedString(@"Menu");
    [self.homeMapButton setTitle:LocalizedString(@"Home map") forState:UIControlStateNormal];
    [self.profileButton setTitle:LocalizedString(@"Profile") forState:UIControlStateNormal];
    [self.newsCommunityButton setTitle:LocalizedString(@"Open a new community") forState:UIControlStateNormal];
    [self.joiningRequestButton setTitle:LocalizedString(@"Joining request") forState:UIControlStateNormal];
    [self.joinRequsetsButton setTitle:LocalizedString(@"Join requests") forState:UIControlStateNormal];
    [self.myMeetingButton setTitle:LocalizedString(@"My meetings") forState:UIControlStateNormal];
    [self.myCommunitysButton setTitle:LocalizedString(@"My Communities") forState:UIControlStateNormal];
    [self.aboutButton setTitle:LocalizedString(@"About") forState:UIControlStateNormal];
    [self.loguotButton setTitle:LocalizedString(@"Log Out") forState:UIControlStateNormal];
    [self.reportButton setTitle:LocalizedString(@"Report a problem") forState:UIControlStateNormal];
//    _imageProfile.image = [UIImage imageNamed:@"ZoomGalaProfileDefult"];
//    
//    if (!StringIsNilOrEmpty([appDelegate.userProfile valueForKey:@"UserImage"])) {
//        NSURL *animationUrl = [NSURL URLWithString:[appDelegate.userProfile valueForKey:@"UserImage"]];
//        if (!StringIsNilOrEmpty(animationUrl.pathExtension)) {
//            _imageProfile.image = nil;
//            [_imageProfile loadFromURL:animationUrl];
//        }
//    }
//    
//    NSString *name;
//    if (!StringIsNilOrEmpty ([appDelegate.userProfile valueForKey:@"userFullName"])){
//        name = [appDelegate.userProfile valueForKey:@"userFullName"];
//    }else{
//        name = [appDelegate.userProfile valueForKey:@"userZoomName"];
//    }
//
//    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    _nameProfile.text = name;
//    
//    _numberMessege.text = [[appDelegate.notificationMessegeArray objectAtIndex:0]valueForKey:@"MessageCount"];
//    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(ShowNumberMessage) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    self.headerLabel.text = LocalizedString(@"Menu");
    [self.homeMapButton setTitle:LocalizedString(@"Home map") forState:UIControlStateNormal];
    [self.profileButton setTitle:LocalizedString(@"Profile") forState:UIControlStateNormal];
    [self.newsCommunityButton setTitle:LocalizedString(@"Open a new community") forState:UIControlStateNormal];
    [self.joiningRequestButton setTitle:LocalizedString(@"Joining request") forState:UIControlStateNormal];
    [self.joinRequsetsButton setTitle:LocalizedString(@"Join requests") forState:UIControlStateNormal];
    [self.myMeetingButton setTitle:LocalizedString(@"My meetings") forState:UIControlStateNormal];
    [self.myCommunitysButton setTitle:LocalizedString(@"My Communities") forState:UIControlStateNormal];
    [self.aboutButton setTitle:LocalizedString(@"About") forState:UIControlStateNormal];
    [self.loguotButton setTitle:LocalizedString(@"Log Out") forState:UIControlStateNormal];
    [self.reportButton setTitle:LocalizedString(@"Report a problem") forState:UIControlStateNormal];
}

- (IBAction)homeButton:(id)sender {
//    [_searchTextField resignFirstResponder];
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MapViewController class]])
    {
        MapViewController *mapViewController = [[MapViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
//    _numberMessege.text = [[appDelegate.notificationMessegeArray objectAtIndex:0]valueForKey:@"MessageCount"];
}

- (IBAction)aboutButton:(id)sender {

    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[AboutViewController class]])
    {
        AboutViewController *homeViewController = [[AboutViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

- (IBAction)logOut:(id)sender {
//    [_searchTextField resignFirstResponder];

    NSArray *pathsNewUser = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathNewUser = [[pathsNewUser objectAtIndex:0]stringByAppendingPathComponent:@"newUserFiles.plist"];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:pathNewUser error:&error];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"StatusSign"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Later"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[StartViewController class]])
    {
        StartViewController *homeViewController = [[StartViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
    
//    LoginViewController *loginViewController = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:loginViewController animated:YES];
}

- (IBAction)profileButton:(id)sender {

    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[ProfileViewController class]])
    {
        ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
        [revealController setFrontViewController:navigationController animated:NO];
        
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setHeaderLabel:nil];
    [self setHomeMapButton:nil];
    [self setProfileButton:nil];
    [self setNewsCommunityButton:nil];
    [self setJoiningRequestButton:nil];
    [self setJoinRequsetsButton:nil];
    [self setMyMeetingButton:nil];
    [self setMyCommunitysButton:nil];
    [self setAboutButton:nil];
    [self setLoguotButton:nil];
    [self setReportButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)myCommunityButtonPress:(id)sender {
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MyCommunityViewController class]])
    {
        MyCommunityViewController *mapViewController = [[MyCommunityViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        mapViewController.fromMap = NO;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

- (IBAction)newCommunityPress:(id)sender {
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[NewCommunitiesViewController class]])
    {
        NewCommunitiesViewController *mapViewController = [[NewCommunitiesViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        mapViewController.isFirst = NO;
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

- (IBAction)myMeetingsButtonPress:(id)sender {
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[MyMeetingsViewController class]])
    {
        MyMeetingsViewController *mapViewController = [[MyMeetingsViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

- (IBAction)joinRequestsButtonPress:(id)sender {
    RevealController *revealController = [self.parentViewController isKindOfClass:[RevealController class]] ? (RevealController *)self.parentViewController : nil;
    
    if ([revealController.frontViewController isKindOfClass:[UINavigationController class]] && ![((UINavigationController *)revealController.frontViewController).topViewController isKindOfClass:[JoinRequestsViewController class]])
    {
        JoinRequestsViewController *mapViewController = [[JoinRequestsViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
        [revealController setFrontViewController:navigationController animated:NO];
    }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
    else
    {
        [revealController revealToggle:self];
    }
}

@end