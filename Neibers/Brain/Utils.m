//
//  Utils.m
//  evon
//
//  Created by Dude on 8/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import "SBJsonParser.h"
#import "JSON.h"

@implementation Utils

+ (BOOL)validateEmail:(NSString *)candidate
{
    if (candidate == nil || [candidate isEqualToString:@""])
    {
        return YES;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:candidate];
}

+ (NSDictionary *)parseJSON:(NSString *)jsonStr
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *dic = [parser objectWithString:jsonStr];
    return dic;
}

+ (void)showAlert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+ (BOOL)isEmpty:(NSString*)string
{
    return (string == nil || string == (id)[NSNull null] || [string isEqualToString:@""]);
}

+ (void)setWidth:(CGFloat)width forView:(UIView*)view
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

@end
