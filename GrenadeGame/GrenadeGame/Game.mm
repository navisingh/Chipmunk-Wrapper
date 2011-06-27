//
//  Game.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Utils.h"
#import "SceneMain.h"
#import "SceneSettings.h"

@interface Game ()
- (id) initWithDefaults;
- (void) didAttachStageToView;
- (void) archiveData;
@end

@implementation Game

@synthesize mainScene = mainScene_;
@synthesize settingsScene = settingsScene_;

-(void) encodeWithCoder:(NSCoder *)encoder 
{
 	NSLog(@"%s", __PRETTY_FUNCTION__);
	
 	[settingsScene_ encodeWithCoder:encoder];
	[mainScene_ encodeWithCoder:encoder];
}

-(id) initWithCoder:(NSCoder *)decoder 
{
 	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	settingsScene_ = [[SceneSettings alloc] initWithCoder:decoder];
    [super addScene:settingsScene_];
    
	mainScene_ = [[SceneMain alloc] initWithCoder:decoder];
    [super addScene:mainScene_];
    
	return [super initWithCoder:decoder];
}

-(id) initWithDefaults
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	settingsScene_ = [[SceneSettings alloc] initWithDefaults];
    [super addScene:settingsScene_];
    
	mainScene_ = [[SceneMain alloc] initWithDefaults];
    [super addScene:mainScene_];
    
    return [super initWithDefaults];
}

- (id)init 
{
	[super init];
    
    pivot_ = [[SPSprite alloc] init];
    [self addChild:pivot_];
    
    pivot_.x = 0;
    pivot_.y = height_;
    pivot_.rotation = SP_D2R(-90);
    pivot_.scaleY = width_ / height_;
    pivot_.scaleX = height_ / width_;
    
	return self;
}

- (void) didAttachStageToView
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
    
    [self setupScenesWithHeight:height_ width:width_];

    [pivot_ addChild:settingsScene_];
    settingsScene_.visible = false;
    
    [pivot_ addChild:mainScene_];
	mainScene_.visible = true;
}


#define ARCHIVE_FILE @"settings.data"

- (void) archiveData
{
    [NSKeyedArchiver archiveRootObject:self toFile:pathInDocumentDirectory(ARCHIVE_FILE)];	
	NSLog(@"Done archiving");
}

+ (void) archiveData:(SPStage *)game
{
	if ([game isKindOfClass:[Game class]])
        [(Game *)game archiveData];
}

+ (Game *)stageWithController:(UIViewController *)controller
                         view:(SPView *)view
{    
    [[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    
	Game *game;
    game = [[NSKeyedUnarchiver unarchiveObjectWithFile:pathInDocumentDirectory(ARCHIVE_FILE)] retain];
	if (!game)
		game = [[Game alloc] initWithDefaults];
	view.stage = game; //bumps retain count 
    game.viewController = controller;
    
	[game didAttachStageToView]; //to work around _SET_STAGE notification bug.
    
	return [game autorelease];
}



@end
