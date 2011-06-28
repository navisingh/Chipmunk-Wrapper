//
//  Scene.h
//  QinCheckers
//
//  Created by Navi Singh on 3/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Stage;

@interface Scene : SPSprite <NSCoding> {
	Stage *stage_;
    int height_;
    int width_;
	int testEncoding_;
    UIView *sparrowView_;
}
@property (nonatomic, retain) Stage *stage;

- (id) initWithDefaults;

- (void) setupScene:(Stage *) gs height:(int)h width:(int)w;
- (void) sceneWillAppear:(Scene *)hide;
- (void) sceneWillDisappear:(Scene *)show;
- (void) sceneDidAppear;
- (void) sceneDidDisappear;
- (void) onOrientationChange:(UIInterfaceOrientation)orientation;

@end
