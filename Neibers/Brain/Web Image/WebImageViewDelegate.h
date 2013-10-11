//
//  WebImageViewDelegate.h
//  CoffeeConnect
//
//  Created by Ivan Chubov on 3/2/12.
//  Copyright 2012 Ideas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@protocol WebImageViewDelegate <NSObject>

- (void)imageDidFinishLoading:(UIImage *)image;

@end
