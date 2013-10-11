//
//  NSString+URLEncoding.h
//  Pick2Print
//
//  Created by Lior and Yonatan Betzer on 6/18/12.
//  Copyright (c) 2012 Bacchus Software Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
