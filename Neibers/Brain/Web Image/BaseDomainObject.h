//
//  BaseDomainObject.h
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Base domain object.
 */
@interface BaseDomainObject : NSObject<NSCoding>

@property (nonatomic, retain) NSString *objectId;

+ (id)object;

@end
