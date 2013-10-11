//
//  MyCommunityViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 09/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "DomainObjects.h"
#import "WebImageView.h"

@class RevealController;

@interface MyCommunityViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *communityArray;
    NSMutableArray *articles;
}

@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (assign, nonatomic) BOOL fromMap;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic, retain) Article *article;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backPress:(id)sender;

@end
