//
//  Scene.m
//  QinCheckers
//
//  Created by Navi Singh on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Scene.h"
#import "Stage.h"

@implementation Scene
@synthesize stage = stage_;

-(void) encodeWithCoder:(NSCoder *)encoder 
{
//	testEncoding_ = 1234;
//    [encoder encodeInt:testEncoding_ forKey:@"scene.test data"];
}

-(id) initWithCoder:(NSCoder *)decoder
{
//	testEncoding_ = [decoder decodeIntForKey:@"scene.test data"];
//	NSAssert(testEncoding_ == 1234, @"failed encoding/decoding test!!");
	
    return [self init];
}

- (id) initWithDefaults
{
    return [self init];
}

- (void)setupScene:(Stage *) gs height:(int)h width:(int)w
{
    stage_ = gs;
    height_ = h;
    width_ = w;

	//note: only the game stage has nativeView set.
    sparrowView_ = (UIView *)stage_.stage.nativeView;
	
    SPQuad *quad = [SPQuad quadWithWidth:w height:h];
    quad.color = 0x00ff00;
    quad.x = 0;
    quad.y = 0;
    [self addChild:quad];    
}

- (void) sceneWillAppear:(Scene *)hide
{
    
}

- (void) sceneWillDisappear:(Scene *)show
{
    
}
- (void) sceneDidAppear
{
    
}
- (void) sceneDidDisappear
{
    
}


@end
