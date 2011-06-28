//
//  Pivot.h
//  GrenadeGame
//
//  Created by Navi Singh on 6/28/11.
//  Copyright 2011 NaviGamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Stage;

@interface Pivot : SPSprite {
	Stage *stage_;
    
    bool enableRotation_;
	float rotation_;
    UIInterfaceOrientation initialOrientation_;
    UIDeviceOrientation currentOrientation_;
}
@property (nonatomic, retain) Stage *stage;

- (id) init:(Stage *)gs;
- (void) enableRotation:(bool)enable;

@end
