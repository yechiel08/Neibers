//
//  iOSChatClientAppDelegate.h
//  iOSChatClient
//
//  Created by Jack Herrington on 9/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iOSChatClientViewController;

@interface iOSChatClientAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iOSChatClientViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iOSChatClientViewController *viewController;

@end

