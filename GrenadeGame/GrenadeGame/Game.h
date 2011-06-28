//
//  Game.h
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stage.h"

@class SceneSettings;
@class SceneMain;

@interface Game : Stage {
	SceneSettings *settingsScene_;
	SceneMain *mainScene_;
}

@property (nonatomic, retain) SceneSettings *settingsScene;
@property (nonatomic, retain) SceneMain *mainScene;


+ (Game *)stageWithController:(UIViewController *)controller
                         view:(SPView *)view;
+ (void)archiveData:(SPStage *)game;

@end
