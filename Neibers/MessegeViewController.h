//
//  MessegeViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 06/10/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebImageView.h"
#import "DomainObjects.h"
#import "AppDelegate.h"
#import "SenderBrain.h"
#import <QuartzCore/QuartzCore.h>
#import "Article.h"
#import "UIBubbleTableViewDataSource.h"

@interface MessegeViewController : UIViewController <UIBubbleTableViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet WebImageView *profileWebImage;
@property (strong, nonatomic) Article *deteilCommunity;

- (IBAction)backPress:(id)sender;

@end
