//
//  ArticleCell.h
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "DomainObjects.h"
#import "WebImageView.h"

#define MY_COMMUNITY_CELL_ID @"MyCommunityCell"

@interface MyCommunityCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageType;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *numberFriends;

@property (nonatomic, retain) Article *article;


@end
