//
//  AppDelegate.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "AppViewController.h"

void onUncaughtException(NSException *exception)
{
    NSLog(@"uncaught exception at: %@", exception.description);
}

@implementation AppDelegate


@synthesize window=_window;
@synthesize appViewController=appViewController_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSSetUncaughtExceptionHandler(&onUncaughtException);
	
 	// Override point for customization after application launch.
	[application setStatusBarHidden:YES];
	
	//Since we are not using mainwindow.xib, we have to explicitly set the window and view controller.
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	appViewController_ = [[AppViewController alloc] init];
	if ([window_ respondsToSelector:@selector(setRootViewController:)]) 
		[window_ setRootViewController:appViewController_]; 		
	else //pre-ios4.0++
		[window_ addSubview:appViewController_.view];
	
    [window_ makeKeyAndVisible];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[appViewController_ applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
	[appViewController_ applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
	[appViewController_ applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	[appViewController_ applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
	[appViewController_ applicationWillTerminate:application];
}

- (void)dealloc
{
    [_window release];
    [appViewController_ release];
    [super dealloc];
}

@end
