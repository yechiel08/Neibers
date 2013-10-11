//
//  UIView+UIViewExtentions.h
//  FedEx
//
//  Created by Ivan Chubov on 5/22/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#define ViewX(VIEW) VIEW.frame.origin.x
#define ViewY(VIEW) VIEW.frame.origin.y
#define ViewWidth(VIEW) VIEW.frame.size.width
#define ViewHeight(VIEW) VIEW.frame.size.height
#define SetViewX(VIEW, X) VIEW.frame = CGRectMake(X, VIEW.frame.origin.y, VIEW.frame.size.width, VIEW.frame.size.height)
#define SetViewY(VIEW, Y) VIEW.frame = CGRectMake(VIEW.frame.origin.x, Y, VIEW.frame.size.width, VIEW.frame.size.height)
#define SetViewWidth(VIEW, WIDHT) VIEW.frame = CGRectMake(VIEW.frame.origin.x, VIEW.frame.origin.y, WIDTH, VIEW.frame.size.height)
#define SetViewHeight(VIEW, HEIGHT) VIEW.frame = CGRectMake(VIEW.frame.origin.x, VIEW.frame.origin.y, VIEW.frame.size.width, HEIGHT)
#define ViewBorderY(VIEW) ViewY(VIEW) + ViewHeight(VIEW)
#define ViewBorderX(VIEW) ViewX(VIEW) + ViewWidth(VIEW)
#define SetViewPosition(VIEW, POSITION) VIEW.frame = CGRectMake(POSITION.x, POSITION.y, VIEW.frame.size.width, VIEW.frame.size.height)
#define ViewPosition(VIEW) VIEW.frame.origin
#define SetViewSize(VIEW, SIZE) VIEW.frame = CGRectMake(VIEW.frame.origin.x, VIEW.frame.origin.y, SIZE.width, SIZE.height)
#define ViewSize(VIEW) VIEW.frame.size

@interface UIView (UIViewExtentions)

@property CGPoint position;
@property CGSize size;

- (void)setPositionX:(CGFloat)positionX;
- (void)setPositionY:(CGFloat)positionY;
- (void)setSizeWidth:(CGFloat)sizeWidth;
- (void)setSizeHeight:(CGFloat)sizeHeight;
- (void)addToPosition:(CGPoint)addValue;
- (void)addToSize:(CGSize)addValue;
- (void)addToPositionX:(CGFloat)addValue;
- (void)addToPositionY:(CGFloat)addValue;
- (void)addToSizeWidth:(CGFloat)addValue;
- (void)addToSizeHeight:(CGFloat)addValue;

- (void)setRotation:(float)angel animated:(BOOL)animated;

/**
 Create view from nib file.
 
 @param nibName The name of nib file without extention(.xib);
 */
+ (id)viewWithNibNamed:(NSString *)nibName;

/**
 Create view from nib file, whose name is same as class name.
 */
+ (id)viewWithNib;

/**
 Get current first responder.
 */
- (UIView *)currentFirstResponder;

+(void)addLinearGradientToView:(UIView*)view TopColor:(UIColor*)topColor BottomColor:(UIColor*)bottomColor;

@end
