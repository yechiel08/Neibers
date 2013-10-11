//
//  UIImage+UIImageExtentions.m
//  Yenta
//
//  Created by Ivan Chubov on 7/26/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "UIImage+UIImageExtentions.h"

@implementation UIImage (UIImageExtentions)

- (UIImage *)imageResizedWithFrame:(CGRect)resizeFrame {    
    float ratio = self.size.width/self.size.height;
    float scaleRate = 1.0f;
    if (ratio >= 1) {
        scaleRate = resizeFrame.size.height/self.size.height;
    } else {
        scaleRate = resizeFrame.size.width/self.size.width;
    }
    
    CGRect bounds = CGRectMake(0, 0, self.size.width * scaleRate, self.size.height * scaleRate);
    UIGraphicsBeginImageContext(bounds.size);
    [self drawInRect:CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage *)crop:(CGRect)rect {
    
    rect = CGRectMake(rect.origin.x*self.scale,
                      rect.origin.y*self.scale,
                      rect.size.width*self.scale,
                      rect.size.height*self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef
                                          scale:self.scale
                                    orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)crop1:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

@end
