//
//  UIImage+UIImageExtentions.h
//  Yenta
//
//  Created by Ivan Chubov on 7/26/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExtentions)

- (UIImage *)imageResizedWithFrame:(CGRect)resizeFrame;
- (UIImage *)crop:(CGRect)rect;
- (UIImage *)crop1:(CGRect)rect;

@end
