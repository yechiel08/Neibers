//
//  UIAlertView+UIAlertViewExtentions.m
//  Lychee
//
//  Created by Danila Drobot on 5/26/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "UIAlertView+UIAlertViewExtentions.h"
#import <objc/runtime.h>

@implementation UIAlertView (UIAlertViewExtentions)

- (void)setUserInfo:(NSObject *)userInfo {
    objc_setAssociatedObject(self, @"userInfo", userInfo, OBJC_ASSOCIATION_RETAIN);
}

- (NSObject *)userInfo {
    return objc_getAssociatedObject(self, @"userInfo");
}

+ (void)alertWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:message
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
