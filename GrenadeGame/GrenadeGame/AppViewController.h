//
//  GrenadeGameViewController.h
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sparrow.h"

@interface AppViewController : UIViewController {
	SPView *sparrowView_; 
}

- (void)archiveData;

- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;

@end
