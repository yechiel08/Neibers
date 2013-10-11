//
//  NSString+NSStringExtentions.h
//  Lychee
//
//  Created by Ivan Chubov on 5/24/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

#define StringIsNilOrEmpty(__STRING__) [NSString isNilOrEmpty:__STRING__]
#define IntToString(INT) [NSString stringWithFormat:@"%i", INT]
#define FloatToString(FLOAT) [NSString stringWithFormat:@"%f", FLOAT]

@interface NSString (NSStringExtentions)

/*
 Returns YES if string is nil or empty;
 */
+ (BOOL)isNilOrEmpty:(NSString *)string;

/*
 Returns YES if string is email; 
 */
+ (BOOL)isEmail:(NSString *)string;

/*
 Calculate md5 for current string;
 */
- (NSString *)md5;

@end
