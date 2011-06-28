//
//  Stage.m
//  QinCheckers
//
//  Created by Navi Singh on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Stage.h"
#import "Scene.h"
#import "Pivot.h"
@implementation Stage

@synthesize viewController = viewController_;

-(void) encodeWithCoder:(NSCoder *)encoder 
{

}


-(id) initWithCoder:(NSCoder *)decoder 
{	
	return [self init];
}


-(id) initWithDefaults
{
	return [self init];
}

- (id)init 
{
    [super init];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    height_ = screenSize.height;
    width_ = screenSize.width;
    
    [self setupPivot];
    
	return self;
}

- (void) addScene:(Scene *)scene
{
    vecScenes_.push_back(scene);
}

- (void) didAttachStageToView
{
    [self setupScenesWithHeight:height_ width:width_];
}

- (void) setupScenesWithHeight:(short)h width:(short)w
{
    for (int n=0, nMax = vecScenes_.size(); n < nMax; ++n) {
        Scene *scene = vecScenes_[n];
        [scene setupScene:self height:h width:w];
    }
}

- (void) displayScene:(Scene *)show sender:(Scene *)hide
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	
	SPDisplayObjectContainer *owner = self;
	
	[self sceneWillDisappear:show sender:hide];
	[self sceneWillAppear:show sender:hide];
	
	if(![owner containsChild:show])
	{
		[show retain];
		[self removeChild:show];
		[self addChild:show];
		[show release];
	}
	else {
		[show retain];
		[owner removeChild:show];
		[owner addChild:show];
		[show release];	
	}
}

- (void) sceneWillAppear:(Scene *)show sender:(Scene *)hide
{
	[show sceneWillAppear:hide]; //notify the Scene
	show.visible = true;
    [show sceneDidAppear];
}

- (void) sceneWillDisappear:(Scene *)show sender:(Scene *)hide
{
	[hide sceneWillDisappear:show]; //notify the Scene
	if (hide) 
		hide.visible = false;
    [hide sceneDidDisappear];
}

-(void) onOrientationChange:(UIInterfaceOrientation)orientation 
{
    for (int n=0, nMax = vecScenes_.size(); n < nMax; ++n) {
        Scene *scene = vecScenes_[n];
        if([pivot_ containsChild:scene])
            [scene onOrientationChange:orientation];
    }
}

- (void) setupPivot
{
	pivot_ = [[Pivot alloc] init:self];
	[self addChild:pivot_];	
}

- (void) enableRotation:(bool)enable
{
    [pivot_ enableRotation:enable];
}

- (void)dealloc {
	
    [super dealloc];
}




@end
