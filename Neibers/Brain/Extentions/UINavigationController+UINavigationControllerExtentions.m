//
//  UINavigationController+UINavigationControllerExtentions.m
//  Yenta
//
//  Created by Ivan Chubov on 5/29/12.
//  Copyright (c) 2012 Ideas. All rights reserved.
//

#import "UINavigationController+UINavigationControllerExtentions.h"

@implementation UINavigationController (UINavigationControllerExtentions)

- (void)popToViewControllerWithClass:(Class)viewControllerClass animated:(BOOL)animated {
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:viewControllerClass] && viewController != self.visibleViewController) {
            [self popToViewController:viewController animated:animated];
        }
    }
}

@end
