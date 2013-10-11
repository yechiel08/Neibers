//
//  UIView+UIViewExtentions.m
//  FedEx
//
//  Created by Ivan Chubov on 5/22/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "UIView+UIViewExtentions.h"

@implementation UIView (UIViewExtentions)

+ (id)viewWithNibNamed:(NSString *)nibName {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    if (views && views.count > 0) {
        return [views objectAtIndex:0];
    }
    
    return nil;
}

+ (id)viewWithNib {
    return [self viewWithNibNamed:NSStringFromClass([self class])];
}

- (CGPoint)position {
    return self.frame.origin; // TODO: this is not correct, need use bounds + center.
}

- (void)setPosition:(CGPoint)position {
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void)setPositionX:(CGFloat)positionX {
    self.frame = CGRectMake(positionX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setPositionY:(CGFloat)positionY {
    self.frame = CGRectMake(self.frame.origin.x, positionY, self.frame.size.width, self.frame.size.height);
}

- (void)setSizeWidth:(CGFloat)sizeWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sizeWidth, self.frame.size.height);
}

- (void)setSizeHeight:(CGFloat)sizeHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sizeHeight);
}

- (void)addToPosition:(CGPoint)addValue {
    self.frame = CGRectMake(self.frame.origin.x + addValue.x, self.frame.origin.y + addValue.y, self.frame.size.width, self.frame.size.height);
}

- (void)addToSize:(CGSize)addValue {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + addValue.width, self.frame.size.height + addValue.height);
}

- (void)addToPositionX:(CGFloat)addValue {
    self.frame = CGRectMake(self.frame.origin.x + addValue, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)addToPositionY:(CGFloat)addValue {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + addValue, self.frame.size.width, self.frame.size.height);
}

- (void)addToSizeWidth:(CGFloat)addValue {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width + addValue, self.frame.size.height);
}

- (void)addToSizeHeight:(CGFloat)addValue {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height + addValue);
}

- (void)setRotation:(float)angel animated:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
    }
    
    if (angel != 0) {
        self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(angel));
    } else {
        self.transform = CGAffineTransformIdentity;
    }
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (UIView *)currentFirstResponder {
    if (self.isFirstResponder) {
        return self;
    }
    
    for (UIView *view in self.subviews) {
        UIView *firstResponder = [view currentFirstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    
    return nil;
}

+(void)addLinearGradientToView:(UIView*)view TopColor:(UIColor*)topColor BottomColor:(UIColor*)bottomColor
{
    for(CALayer* layer in view.layer.sublayers)
    {
        if ([layer isKindOfClass:[CAGradientLayer class]])
        {
            [layer removeFromSuperlayer];
        }
    }
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    //top down gradient
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5,1);
    gradientLayer.frame = view.bounds;
    
    
    
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    
    [view.layer insertSublayer:gradientLayer atIndex:0];
    
}
@end
