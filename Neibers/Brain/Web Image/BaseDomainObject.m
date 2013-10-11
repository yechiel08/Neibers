//
//  BaseDomainObject.m
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "BaseDomainObject.h"

@implementation BaseDomainObject

@synthesize objectId;

+ (id)object {
    return [[self alloc] init];
}

#pragma mark - NSCoding implementaion

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.objectId = [aDecoder decodeObjectForKey:@"objectId"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.objectId forKey:@"objectId"];
}

@end
