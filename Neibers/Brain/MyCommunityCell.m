//
//  ArticleCell.m
//  iBabySitter
//
//  Created by Yechiel Amar on 02/07/12.
//  Copyright (c) 2012 yramar08@gmail.com. All rights reserved.
//

#import "MyCommunityCell.h"
#import "Extentions.h"

@implementation MyCommunityCell
@synthesize article;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(245/255.0) green:(245/255.0) blue:(245/255.0) alpha:1];
        self.selectedBackgroundView = selectionColor;
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

-(void)setArticle:(Article *)_article{
    
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
    if ([_article.numberType isEqualToString:@"1"]) {
        iconFilename = @"Home_on-1";
    } else if ([_article.numberType isEqualToString:@"2"]){
        iconFilename = @"Mother_children_on-1";
    } else if ([_article.numberType isEqualToString:@"3"]){
        iconFilename = @"Hands_on-1";
    } else if ([_article.numberType isEqualToString:@"4"]){
        iconFilename = @"School_on-1";
    } else if ([_article.numberType isEqualToString:@"5"]){
        iconFilename = @"Sport_on-1";
    } else if ([_article.numberType isEqualToString:@"6"]){
        iconFilename = @"Girl_on-1";
    } else if ([_article.numberType isEqualToString:@"7"]){
        iconFilename = @"Animals_on-1";
    } else if ([_article.numberType isEqualToString:@"8"]){
        iconFilename = @"Road_on-1";
    } else if ([_article.numberType isEqualToString:@"9"]){
        iconFilename = @"Industry_on-1";
    } else if ([_article.numberType isEqualToString:@"10"]){
        iconFilename = @"Hammer_on-1";
    } else if ([_article.numberType isEqualToString:@"11"]){
        iconFilename = @"Tie_on-1";
    } else if ([_article.numberType isEqualToString:@"12"]){
        iconFilename = @"University_on-1";
    } else if ([_article.numberType isEqualToString:@"13"]){
        iconFilename = @"Synagogue_on-1";
    } else if ([_article.numberType isEqualToString:@"14"]){
        iconFilename = @"Church_on-1";
    } else if ([_article.numberType isEqualToString:@"15"]){
        iconFilename = @"Mosque_on-1";
    } else if ([_article.numberType isEqualToString:@"16"]){
        iconFilename = @"Music_on-1";
    } else if ([_article.numberType isEqualToString:@"17"]){
        iconFilename = @"Restaurant_on-1";
    } else if ([_article.numberType isEqualToString:@"18"]){
        iconFilename = @"Cafe_on-1";
    } else if ([_article.numberType isEqualToString:@"19"]){
        iconFilename = @"Pub_on-1";
    } else if ([_article.numberType isEqualToString:@"20"]){
        iconFilename = @"Star_on-1";
    }
    UIImage *pinImage = [UIImage imageNamed:iconFilename];
    _imageType.image = pinImage;
    
    _numberFriends.text = _article.numberFriends;
    _name.text = _article.name;
}

@end
