//
//  Utils.h
//  evon
//
//  Created by Dude on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)validateEmail:(NSString *)candidate;
+ (NSDictionary *)parseJSON:(NSString *)jsonStr;
+ (void)showAlert:(NSString*)message;
+ (BOOL)isEmpty:(NSString*)string;
+ (void)setWidth:(CGFloat)width forView:(UIView*)view;

@end
