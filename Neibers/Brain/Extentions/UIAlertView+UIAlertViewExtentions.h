//
//  UIAlertView+UIAlertViewExtentions.h
//  Lychee
//
//  Created by Danila Drobot on 5/26/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Alert(__MESSAGE__) [UIAlertView alertWithMessage:__MESSAGE__]

@interface UIAlertView (UIAlertViewExtentions)

@property (nonatomic, retain) NSObject *userInfo;

+ (void)alertWithMessage:(NSString *)message;

@end
