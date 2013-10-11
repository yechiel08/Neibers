//
//  AboutViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 02/09/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RevealController;

@interface AboutViewController : UIViewController

@property (strong, nonatomic) RevealController *viewController;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;

@end
