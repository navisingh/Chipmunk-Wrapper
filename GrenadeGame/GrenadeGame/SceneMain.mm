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

@interface SceneMain ()
- (void) onOKButton:(SPEvent *)event;
@end

@implementation SceneMain

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
    
	return self;
}

- (void) setupScene:(Stage *) s height:(int)h width:(int)w
{
    [super setupScene:s height:h width:w];
    Game *gs = (Game *) s;
    
    
    // if this quad does not dispay and you get a purple screen on the simulator
    // verify that you have the 
    // "other linker flags" field in your target' "build settings" set to "-all_load -ObjC"
    SPQuad *quad = [SPQuad quadWithWidth:200 height:200];
    quad.color = 0x0000ff;
    quad.x = 50;
    quad.y = 50;
    [self addChild:quad];
    
    SPTexture *texture = [SPTexture emptyTexture];
    SPButton *button = [SPButton buttonWithUpState:texture text:@"OK"];
    [self addChild:button];
    button.x = w / 2;
    button.y = h - 50;
    [button addEventListener:@selector(onOKButton:) atObject:self forType:SP_EVENT_TYPE_TRIGGERED];
}

- (void)onOKButton:(SPEvent *)event 
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
    Game *gs = (Game *)stage_;
	[gs displayScene:gs.settingsScene sender:self];
}

@end
