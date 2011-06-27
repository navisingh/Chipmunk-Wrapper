//
//  SceneMain.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SceneMain.h"
#import "SceneSettings.h"
#import "Game.h"
#include "SPDebugDraw.h"


#define TANK_COLLISION_TYPE @"tank"
#define TURRET_COLLISION_TYPE @"turret"
#define CANNON_COLLISION_TYPE @"cannon"
#define CRATE_COLLISION_TYPE @"crate"


@interface SceneMain ()
- (void) onOKButton:(SPEvent *)event;


- (void)onLeftThumstickChanged:(SHThumbstickEvent *)event;
- (void)onRightThumstickChanged:(SHThumbstickEvent *)event;

- (void) setupChipmunkSpace;
- (void) initializeChipmunkObjects;
- (void) createConsole;
- (void) loadPlayer;
- (void) addCrate:(int)xPos yPos:(int)yPos;

// Collision handlers: here you will manage how your game reacts to different collisions (play an explosion sound, etc)
- (BOOL) defaultBegin:(CMArbiter*)arbiter space:(CMSpace*)space;
- (BOOL) defaultPreSolve:(CMArbiter*)arbiter space:(CMSpace*)space;
- (BOOL) defaultPostSolve:(CMArbiter*)arbiter space:(CMSpace*)space;
- (BOOL) defaultSeparate:(CMArbiter*)arbiter space:(CMSpace*)space;
@end

@implementation SceneMain

@synthesize chipmunkSpace = chipmunkSpace_;

-(void) encodeWithCoder:(NSCoder *)encoder {
	
    [super encodeWithCoder:encoder];
}

-(id) initWithCoder:(NSCoder *)decoder{
    
    return [super initWithCoder:decoder];
}

- (id) initWithDefaults
{
    return [super initWithDefaults];
}

- (id)init 
{
	[super init];

    // Add the two thumbsticks
    [self createConsole];
    
	return self;
}

- (void) setupScene:(Stage *) s height:(int)h width:(int)w
{
    [super setupScene:s height:h width:w];
    Game *gs = (Game *) s;
    
    
//    // if this quad does not dispay and you get a purple screen on the simulator
//    // verify that you have the 
//    // "other linker flags" field in your target' "build settings" set to "-all_load -ObjC"
//    SPQuad *quad = [SPQuad quadWithWidth:200 height:200];
//    quad.color = 0x0000ff;
//    quad.x = 50;
//    quad.y = 50;
//    [self addChild:quad];
//    
//    SPTexture *texture = [SPTexture emptyTexture];
//    SPButton *button = [SPButton buttonWithUpState:texture text:@"OK"];
//    [self addChild:button];
//    button.x = w / 2;
//    button.y = h - 50;
//    [button addEventListener:@selector(onOKButton:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
    
    // TEMP: bool to see if the left thumbstick is in use
    tankMoving = NO;
    turretTargetAngle = 0;
    
    // Add a container in landscape mode
    mContents = [SPSprite sprite];
    mContents = [[SPSprite alloc] init];
    mContents.rotation = SP_D2R(90);
    mContents.x = width_;
    [self addChild:mContents];
    
    // Add the sprite that will manage the scrolling (no map yet)
    scrollingMap = [SPSprite sprite];
    [mContents addChild:scrollingMap];
    
    // Add the tank
    [self loadPlayer];
    
    // Initialize crates arrays (used just to add some other object)	
    cratesArray = [[NSMutableArray alloc] init];
    cratesBodiesArray = [[NSMutableArray alloc] init];
    
    // Set up the physic space
    [self setupChipmunkSpace];
    
    // Initialize physic objects
    [self initializeChipmunkObjects];
    
    // Turn on/off the debug draw (comment/uncomment the 2 lines to deactivate/activate the debug draw)
    //debugDraw = [[SPDebugDraw alloc] initWithManager:mSpace];
    //[self addChild:debugDraw];
    
    // Add the loop that update the physic objects
    [self addEventListener:@selector(step:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME]; 
    
}

- (void)onOKButton:(SPEvent *)event 
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
    Game *gs = (Game *)stage_;
	[gs displayScene:gs.settingsScene sender:self];
}

- (void)createConsole{
    
	// add the tank thumbstick
	tankThumbstick = [SHThumbstick thumbstick];
	tankThumbstick.innerImage = [SPImage imageWithContentsOfFile:@"inner.png"];
	tankThumbstick.outerImage = [SPImage imageWithContentsOfFile:@"outer.png"];
	tankThumbstick.type = SHThumbstickStatic;
	tankThumbstick.bounds = [SPRectangle rectangleWithX:0 y:0 width:width_ height:height_];
	tankThumbstick.innerRadius = 0;
	tankThumbstick.outerRadius = 32;
	tankThumbstick.debugDraw = NO;
	[self addChild:tankThumbstick];
	tankThumbstick.x = 20;
	tankThumbstick.y = 20;
	[tankThumbstick addEventListener:@selector(onLeftThumstickChanged:) atObject:self forType:SH_THUMBSTICK_EVENT_CHANGED];
	
	// add the turret thumbstick (not used yet) 
	turretThumbstick = [SHThumbstick thumbstick];
	turretThumbstick.innerImage = [SPImage imageWithContentsOfFile:@"inner.png"];
	turretThumbstick.outerImage = [SPImage imageWithContentsOfFile:@"outer.png"];
	turretThumbstick.type = SHThumbstickStatic;
	turretThumbstick.bounds = [SPRectangle rectangleWithX:0 y:0 width:width_ height:height_];
	turretThumbstick.innerRadius = 0;
	turretThumbstick.outerRadius = 32;
	turretThumbstick.debugDraw = NO;
	[self addChild:turretThumbstick];
	turretThumbstick.x = 20;
	turretThumbstick.y = height_ -turretThumbstick.width - 20;
	[turretThumbstick addEventListener:@selector(onRightThumstickChanged:) atObject:self forType:SH_THUMBSTICK_EVENT_CHANGED];
	
}

- (void)setupChipmunkSpace
{	
	// Setup the chipmunk space
	chipmunkSpace_ = [[CMSpace alloc] init];
	[chipmunkSpace_ setSleepTimeThreshhold:5.0f];
	[chipmunkSpace_ setIterations:25];
    
	// Set the gravity to 0,0 because of the top-down view
	[chipmunkSpace_ setGravity:cpv(0,0)];
	
	// Damping will simulate a fake friction in a top-down simulation
	[chipmunkSpace_ setDamping:0.1];
	
	// TEMP: Apply a window containment
	[chipmunkSpace_ addWindowContainmentWithWidth:width_ height:height_ elasticity:0.0 friction:1.0];
	
	// Add the collision handlers (you will probably need them to see wich objects are colliding, see at the end of this class)
	[chipmunkSpace_ addDefaultCollisionHandler:self 
                                         begin:@selector(defaultBegin:space:) 
                                      preSolve:@selector(defaultPreSolve:space:) 
                                     postSolve:@selector(defaultPostSolve:space:) 
                                      separate:@selector(defaultSeparate:space:) 
                   ignoreContainmentCollisions:NO];
}

// Collision handlers: here you will manage how your game reacts to different collisions (play an explosion sound, etc)
- (BOOL) defaultBegin:(CMArbiter*)arbiter space:(CMSpace*)space {
	//NSLog(@"Collision: begin (between %@ and %@)", [[arbiter shapeA] collisionType], [[arbiter shapeB] collisionType]);
	return YES;
}
- (BOOL) defaultPreSolve:(CMArbiter*)arbiter space:(CMSpace*)space {
	//NSLog(@"Collision: preSolve (between %@ and %@)", [[arbiter shapeA] collisionType], [[arbiter shapeB] collisionType]);
	return YES;
}
- (BOOL) defaultPostSolve:(CMArbiter*)arbiter space:(CMSpace*)space {
	//NSLog(@"Collision: postSolve (between %@ and %@)", [[arbiter shapeA] collisionType], [[arbiter shapeB] collisionType]);
	return YES;
}
- (BOOL) defaultSeparate:(CMArbiter*)arbiter space:(CMSpace*)space {
	//NSLog(@"Collision: separate (between %@ and %@)", [[arbiter shapeA] collisionType], [[arbiter shapeB] collisionType]);
	return YES;
}

- (void)loadPlayer {
	
	// There's no need to parent the tank and the turrent, a chipmunk's joint will stick 'em togheter
    mBody = [SPImage imageWithContentsOfFile:@"body.png"];
    mBody.pivotX = mBody.width/2;
	mBody.pivotY = mBody.height/2;
	[mContents addChild:mBody];
    
    mTurret = [SPImage imageWithContentsOfFile:@"turret.png"];
    mTurret.pivotX = mTurret.width/2;
	mTurret.pivotY = mTurret.height/2;
	[mContents addChild:mTurret];
}


- (void)initializeChipmunkObjects
{
	
	// Create the tank body with its shape
	tankBody = [chipmunkSpace_ addBodyWithMass:2.0 moment:INFINITY];
	[tankBody setVelocityFunction:self selector:@selector(tankVelocityFunction:gravity:damping:dt:)];
	[tankBody setPositionUsingVect:cpv(width_ / 2, width_)];	
	[tankBody addToSpace];	
	CMShape *tankShape = [tankBody addRectangleWithWidth:56 height:26 offset:cpv(-9, -1)]; //turn on Debug Draw to see why a little offset is necessary
	[tankShape setLayer:1];
	[tankShape setElasticity:0.8];
	[tankShape setFriction:0.8];
	[tankShape setCollisionType:TANK_COLLISION_TYPE];
	[tankShape addToSpace];
	
	// Create the turret body with its shape
	turretBody = [chipmunkSpace_ addBodyWithMass:2.0 moment:INFINITY];
	[turretBody setPositionUsingVect:cpv(width_ / 2, width_)];	
	[turretBody addToSpace];	
	CMShape *turretShape = [turretBody addRectangleWithWidth:36 height:26 offset:cpv(-6, 0)];
	[turretShape setElasticity:0.8];
	[turretShape setFriction:2.8];
	[turretShape setCollisionType:TURRET_COLLISION_TYPE];
	[turretShape addToSpace];
	[turretShape setLayer:2];
	CMShape *cannonShape = [turretBody addRectangleWithWidth:42 height:6 offset:cpv(30, 0)];
	[cannonShape setElasticity:0.8];
	[cannonShape setFriction:2.8];
	[cannonShape setCollisionType:CANNON_COLLISION_TYPE];
	[cannonShape addToSpace];
	[cannonShape setLayer:2];
	
	// Add a joint to pin the turret to the tank
	CMPivotJointConstraint *turretJoint = [tankBody addPivotJointConstraintWithBody:turretBody pivot:cpv(width_ / 2, width_)];
	[turretJoint addToSpace];
	
	// TEMP: Add some crates to play with
	for (int i=1; i<5; i++) {
		[self addCrate:[SPUtils randomIntBetweenMin:30 andMax:450] yPos:[SPUtils randomIntBetweenMin:30 andMax:290]];		
	}
    
}

- (void)addCrate:(int)xPos yPos:(int)yPos{
	
	// Add the crate in Sparrow
	SPImage *crate = [SPImage imageWithContentsOfFile:@"crate.png"];
	crate.pivotX = crate.width/2;
	crate.pivotY = crate.height/2;
	crate.x = xPos;
	crate.y = width_ - yPos;
	[scrollingMap addChild:crate];
	[cratesArray addObject:crate];
	[crate release];
	
	//Add the crate in Chipmunk
	CMBody *crateBody = [chipmunkSpace_ addBodyWithMass:2 moment:1];
	[crateBody setPositionUsingVect:cpv(yPos, xPos)];
	[crateBody addToSpace];	
	CMShape *crateShape = [crateBody addRectangleWithWidth:40 height:40];
	[crateShape setElasticity:0.5];
	[crateShape setFriction:0.8];
	[crateShape setCollisionType:CRATE_COLLISION_TYPE];
	[crateShape addToSpace];
	[cratesBodiesArray addObject:crateBody];
	[crateBody release];
	
}

- (void)onLeftThumstickChanged:(SHThumbstickEvent *)event
{
	
	// TEMP: just set some coordinates to move the tank in a temp way
	if (event.distance > 0) {
		[tankBody wakeUp];
		targetY = -(sin(SP_D2R(event.direction)) * (event.distance*100));
		targetX = -(cos(SP_D2R(event.direction)) * (event.distance*100));
		tankMoving = YES;
	}else {
		targetY = 0;
		targetX = 0;
		tankMoving = NO;
	}
	
}

- (void)onRightThumstickChanged:(SHThumbstickEvent *)event
{
	
	// Set the turret target rotation
	if (event.distance > 0) {
		[turretBody wakeUp];
		turretTargetAngle = SP_D2R(event.direction - 90);
	}
	
}

- (void)tankVelocityFunction:(CMBody*)cmBody gravity:(cpVect)gravity damping:(float)damping dt:(float)dt {
	
	// This function will override the normal physic behaviour of the tank
	cpBody *body = [cmBody cpBody];
	if (tankMoving) { // if the thumbstick is in use...
		body->v = cpv(-targetY,targetX);// velocity vector
		body->a = atan2(targetY, targetX) + SP_D2R(90);// angle
	}else {
		body->v = cpv(0,0); // reset velocity vector
		body->w = 0; // reset angular velocity (otherwise the tank will rotate influenced by the turret and its collisions)
	}
    
}

- (void)step:(SPEnterFrameEvent *)event{
    
	// Update physic objects	
	[chipmunkSpace_ step:1.0f / 15.0f];
	[chipmunkSpace_ updateShapes];
	
	// Get the tankBody and turretBody coordinates
	CGPoint tankBodyCoords = [tankBody position];	
	float tankBodyAngle = [tankBody angle]; 
	CGPoint turretBodyCoords = [turretBody position];	
	float turretBodyAngle = [turretBody angle]; 
	
	// Apply the physic coordinates to the sprites
	mBody.y = width_ -tankBodyCoords.x;
	mBody.x = tankBodyCoords.y;
	mBody.rotation = tankBodyAngle;	
	mTurret.y = width_ -turretBodyCoords.x;
	mTurret.x = turretBodyCoords.y;
	
	// Rotate the turret to it's targetRotation
	float dr = SP_R2D(turretTargetAngle - turretBodyAngle) ;
	if (abs(dr) > 180) {
		dr = dr > 0 ? dr - 360 : 360 + dr;
	}
	[turretBody setAngle:[turretBody angle] + SP_D2R(dr / 8)];
	mTurret.rotation = [turretBody angle];
	
	// Set the new map coordinates based on the physic world
	//scrollingMap.x = ...;
	//scrollingMap.y = ...;
	
	// Crates
	for (int i=0; i<cratesArray.count; i++) {
		SPSprite *crate = [cratesArray objectAtIndex:i];
		CMBody *crateBody = [cratesBodiesArray objectAtIndex:i];
		CGPoint crateBodyCoords = [crateBody position];	
		float crateBodyAngle = [crateBody angle];
		crate.y = width_ -crateBodyCoords.x;
		crate.x = crateBodyCoords.y;
		crate.rotation = crateBodyAngle;
	}
	
}



@end
