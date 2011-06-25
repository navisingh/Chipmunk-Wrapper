//
//  Stage.h
//  QinCheckers
//
//  Created by Navi Singh on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <vector>

@class Pivot;
@class Scene;

@interface Stage : SPStage  <NSCoding> 
{
    short height_;
    short width_;
    UIViewController *viewController_;
    std::vector<Scene *> vecScenes_;
}
@property (nonatomic, assign) UIViewController *viewController;

- (id) initWithDefaults;
- (void) didAttachStageToView;
- (void) setupScenesWithHeight:(short)h width:(short)w;

- (void) addScene:(Scene *)scene;
- (void) displayScene:(Scene *)show sender:(Scene *)hide;
- (void) sceneWillAppear:(Scene *)show sender:(Scene *)hide;
- (void) sceneWillDisappear:(Scene *)show sender:(Scene *)hide;

@end
