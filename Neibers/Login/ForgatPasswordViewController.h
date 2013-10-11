//
//  ForgatPasswordViewController.h
//  Neibers
//
//  Created by Yechiel Amar on 21/08/13.
//  Copyright (c) 2013 Yechiel Amar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgatPasswordViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *okButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *forgotLabel;
@property (strong, nonatomic) IBOutlet UILabel *fillEmailLabel;

- (IBAction)sendEmailbuttonPress:(id)sender;
- (IBAction)back:(id)sender;
-(IBAction)clickBackground:(id)sender;

@end
