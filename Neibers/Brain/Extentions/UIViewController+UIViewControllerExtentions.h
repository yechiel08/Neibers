//
//  UIViewController+UIViewControllerExtentions.h
//  Lychee
//
//  Created by Ivan Chubov on 5/24/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewControllerExtentions)

/*
 Create view controller;
    nibName - nib file name without '.xib';
 */
+ (id)controllerWithNibNamed:(NSString *)nibName;


@end
