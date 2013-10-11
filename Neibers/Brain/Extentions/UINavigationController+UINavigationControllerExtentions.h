//
//  UINavigationController+UINavigationControllerExtentions.h
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 The UINavigationController extentions.
 */
@interface UINavigationController (UINavigationControllerExtentions)

/**
 Pop to view controller;
 
 @param viewControllerClass The Class of targeted controller;
 @param animated Animate the change of views;
 */
- (void)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated;


@end
