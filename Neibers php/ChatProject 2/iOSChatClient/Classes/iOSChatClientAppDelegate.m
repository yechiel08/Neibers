//
//  iOSChatClientAppDelegate.m
//  iOSChatClient
//
//  Created by Jack Herrington on 9/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "iOSChatClientAppDelegate.h"
#import "iOSChatClientViewController.h"

@implementation iOSChatClientAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
