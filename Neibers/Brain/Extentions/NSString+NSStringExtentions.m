//
//  NSString+NSStringExtentions.m
//  Lychee
//
//  Created by Ivan Chubov on 5/24/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "NSString+NSStringExtentions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSStringExtentions)

+ (BOOL)isNilOrEmpty:(NSString *)string {
    return !string || string.length == 0;
}

+ (BOOL)isEmail:(NSString *)string {
    if (![self isNilOrEmpty:string]) {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
        NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
        
        return [emailPredicate evaluateWithObject:string];
    }
    
    return NO;
}

- (NSString *)md5 {
    const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5(cStr, strlen(cStr), result);
    NSString *md5 = [NSString string];
    for (short i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        md5 = [md5 stringByAppendingFormat:@"%02X", result[i]];
    }
	
    return [md5 lowercaseString];
}

@end
