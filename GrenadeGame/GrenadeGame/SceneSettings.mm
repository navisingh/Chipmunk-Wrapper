//
//  SceneSettings.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SceneSettings.h"
#import "SceneMain.h"
#import "Game.h"

@interface SceneSettings ()
- (void) onOKButton:(SPEvent *)event;
@end

@implementation SceneSettings

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

    SPQuad *quad = [SPQuad quadWithWidth:200 height:200];
    quad.color = 0xff0000;
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
	[gs displayScene:gs.mainScene sender:self];
}


@end
