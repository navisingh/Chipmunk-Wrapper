//
//  Pivot.m
//  GrenadeGame
//
//  Created by Navi Singh on 6/28/11.
//  Copyright 2011 NaviGamer. All rights reserved.
//


#import "Pivot.h"
#import "Stage.h"


// --- private interface ---------------------------------------------------------------------------

@interface Pivot ()

- (void) onOrientationChange:(NSNotification*)notification;
- (void) deviceLandscapeLeft;
- (void) deviceLandscapeRight;
- (void) devicePortrait;
- (void) devicePortraitUpsideDown;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Pivot

@synthesize stage = stage_;

- (id)init:(Stage *)gs
{
    self = [super init];
    if (self) {
		stage_ = gs;
        rotation_ = 0;
        enableRotation_ = false;
        currentOrientation_ = UIDeviceOrientationUnknown;
        
        initialOrientation_ = [[UIApplication sharedApplication] statusBarOrientation];
        switch(initialOrientation_)
        {
            case UIInterfaceOrientationPortrait:
                [self devicePortrait];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                [self devicePortraitUpsideDown];
                break;
            case UIInterfaceOrientationLandscapeLeft:
                [self deviceLandscapeRight];
                break;
            case UIInterfaceOrientationLandscapeRight:
                [self deviceLandscapeLeft];
                break;
        }
        [[NSNotificationCenter defaultCenter]addObserver:self 
                                                selector:@selector(onOrientationChange:) 
                                                    name:UIDeviceOrientationDidChangeNotification 
                                                  object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
   }
    return self;
}

- (void) enableRotation:(bool)enable
{
    enableRotation_ = enable;
}

-(void)onOrientationChange:(NSNotification*)notification 
{
	currentOrientation_ = [[UIDevice currentDevice] orientation];
    
    if (enableRotation_) {
        switch(currentOrientation_)
        {
            case UIDeviceOrientationFaceDown:
            case UIDeviceOrientationFaceUp:
            case UIDeviceOrientationUnknown:
                return;
            case UIDeviceOrientationLandscapeLeft:
                [self deviceLandscapeLeft];
                break;
            case UIDeviceOrientationLandscapeRight:
                [self deviceLandscapeRight];
                break;
            case UIDeviceOrientationPortrait:
                [self devicePortrait];
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                [self devicePortraitUpsideDown];
                break;
        }    
    }
    
    UIInterfaceOrientation orientation;
    switch(currentOrientation_)
    {
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationUnknown:
        case UIDeviceOrientationPortrait:
            orientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
    }    
    
    if (enableRotation_)
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:YES];
    
    [stage_ onOrientationChange:orientation];
}

- (void) deviceLandscapeLeft; {
	NSLog(@"landscapeLeft - button on right");
	rotation_ = SP_D2R(90);
	
	if(self.rotation != rotation_)
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.x = screenSize.width;	
        self.y = 0;			
        
        self.scaleY = screenSize.width / screenSize.height;
        self.scaleX = screenSize.height / screenSize.width;
        self.rotation  = rotation_;        
    }
}

- (void) deviceLandscapeRight {
	NSLog(@"landscapeRight - button on left");
	rotation_ = SP_D2R(-90);
	
	if(self.rotation != rotation_) 
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        
        self.x = 0;			
        self.y = screenSize.height;	
        
        self.scaleY = screenSize.width / screenSize.height;
        self.scaleX = screenSize.height / screenSize.width;
        self.rotation  = rotation_;        
    }
}

- (void) devicePortrait {
	NSLog(@"right way up - button on bottom");
	rotation_ = SP_D2R(0);
	
	if(self.rotation != rotation_) 
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.x = 0;
        self.y = 0;
        
        self.scaleY = 1; 
        self.scaleX = 1; 
        self.rotation  = rotation_;        
    }
}

- (void) devicePortraitUpsideDown {
	NSLog(@"upside down - button on top");
	rotation_ = SP_D2R(180);
	
	if(self.rotation != rotation_) 
    {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        self.x = screenSize.width;
        self.y = screenSize.height;
        
        self.scaleY = 1; 
        self.scaleX = 1; 
        self.rotation  = rotation_;        
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
