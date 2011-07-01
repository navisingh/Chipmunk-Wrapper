//
//  GrenadeGameAppDelegate.h
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window_;
    AppViewController *appViewController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AppViewController *appViewController;

@end
