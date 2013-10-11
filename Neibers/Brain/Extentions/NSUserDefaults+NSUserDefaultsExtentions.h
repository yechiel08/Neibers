//
//  NSUserDefaults+NSUserDefaultsExtentions.h
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (NSUserDefaultsExtentions)

/*
 Set custom object into user defaults;
    object - custom object;
    key - NSUserDefaults key;
 */
- (void)setCustomObject:(NSObject<NSCoding> *)object forKey:(NSString *)key;

/*
 Get custom object from user defaults;
    key - NSUserDefaults key;
 */
- (id)customObjectForKey:(NSString *)key;

@end
