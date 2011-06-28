//
//  SceneMain.h
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scene.h"

@class SPDebugDraw;
@class CMSpace;

@interface SceneMain : Scene {
	// Debug draw
	SPDebugDraw *debugDraw_;
	
	// Physics world
	CMSpace *chipmunkSpace_;

	// Physic bodies
	CMBody *tankBody;
	CMBody *turretBody;
	
	// Main cointaner & scrolling map container
    SPSprite  *mContents2;
	SPSprite *mContents;
	SPSprite *scrollingMap;
	
	// Thumbsticks
	SHThumbstick *tankThumbstick;
	SHThumbstick *turretThumbstick;
	
	// Tank images
	SPImage *mBody;
    SPImage *mTurret;
	
	// TEMP: crates arrays
	NSMutableArray *cratesArray;
	NSMutableArray *cratesBodiesArray;
	
	// Vars for the tank and the turret
	BOOL tankMoving;
	float targetX;
	float targetY;
	float turretTargetAngle;
}
@property (nonatomic, retain) CMSpace *chipmunkSpace;

@end
