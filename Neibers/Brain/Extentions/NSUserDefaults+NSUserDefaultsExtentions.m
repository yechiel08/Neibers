//
//  NSUserDefaults+NSUserDefaultsExtentions.m
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "NSUserDefaults+NSUserDefaultsExtentions.h"

@implementation NSUserDefaults (NSUserDefaultsExtentions)

- (void)setCustomObject:(NSObject<NSCoding> *)object forKey:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:key];
}

- (id)customObjectForKey:(NSString *)key {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (encodedObject) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    } 
    
    return nil;
}

@end
