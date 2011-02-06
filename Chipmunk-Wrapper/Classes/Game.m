//
//  Game.m
//  Chipmunk
//
//  Created by Ronald Mathies on 12/27/10.
//  Copyright Sodeso 2010. All rights reserved.
//

#import "Game.h" 

// --- Static variables ----------------------------------------------------------------------------

// --- Static inline methods -----------------------------------------------------------------------

// --- private interface ---------------------------------------------------------------------------

@interface Game ()

- (void)previousDemo:(SPEvent*)event;
- (void)nextDemo:(SPEvent*)event;
- (void)switchDemo;

@end

// --- Class implementation ------------------------------------------------------------------------

@implementation Game

- (id)initWithWidth:(float)width height:(float)height {
    if (self = [super initWithWidth:width height:height]) {
		selected = -1;
		
		previousDemo = [SPImage imageWithContentsOfFile:@"left.png"];
		previousDemo.x = 5;
		previousDemo.y = 480 - 5 - 32;
		[self addChild:previousDemo];
		[previousDemo addEventListener:@selector(previousDemo:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		
		textField = [SPTextField textFieldWithText:@"Demo"];
		[textField setColor:0xFFFFFF];
		[textField setHAlign:SPHAlignCenter];
		[textField setWidth:320 - ( 2 * 32) - 10];
		[textField setHeight:32];
		[textField setX:32 + 5];
		[textField setY:480 - 5 - 32];
		[textField addEventListener:@selector(showHideDebugDraw:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		
		[self addChild:textField];
		
		nextDemo = [SPImage imageWithContentsOfFile:@"right.png"];
		nextDemo.x = self.stage.width - 5 - [nextDemo width];
		nextDemo.y = 480 - 5 - 32;
		[self addChild:nextDemo];
		[nextDemo addEventListener:@selector(nextDemo:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
   }
	
    return self;
}

- (void)showHideDebugDraw:(SPTouchEvent*)event {
	SPTouch *touch = [[event touchesWithTarget:textField andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		[demo showHideDebugDraw];
	}
}

- (void)previousDemo:(SPTouchEvent*)event {
	SPTouch *touch = [[event touchesWithTarget:previousDemo andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		selected--;
	
		if (selected < 0) {
			selected = 18;
		}
	
		[self switchDemo];
	}
}

- (void)nextDemo:(SPTouchEvent*)event {
	SPTouch *touch = [[event touchesWithTarget:nextDemo andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		selected++;
	
		if (selected == 19) {
			selected = 0;
		}
	
		[self switchDemo];
	}
}

- (void)switchDemo {
	if (demo != nil) {
		[demo stopDemo];
		[self removeChild:demo];
		[demo release];
	}
		
	switch (selected) {
		case 0:
			[textField setText:@"Simple Motor Joint"];
			demo = [[SimpleMotorJointConstraintDemo alloc] init];
			break;
		case 1:
			[textField setText:@"Damped Rotary"];
			demo = [[DampedRotarySpringConstraintDemo alloc] init];
			break;
		case 2:
			[textField setText:@"Damped Spring"];
			demo = [[DampedSpringConstraintDemo alloc] init];
			break;
		case 3:
			[textField setText:@"Slide Joint"];
			demo = [[SlideJointConstraintDemo alloc] init];
			break;
		case 4:
			[textField setText:@"Rotary Limit"];
			demo = [[RotaryLimitConstraintDemo alloc] init];
			break;
		case 5:
			[textField setText:@"Pin Joint"];
			demo = [[PinJointConstraintDemo alloc] init];
			break;
		case 6:
			[textField setText:@"Ratchet Joint"];
			demo = [[RatchetJointConstraintDemo alloc] init];
			break;
		case 7:
			[textField setText:@"Groove Joint"];
			demo = [[GrooveJointConstraintDemo alloc] init];
			break;
		case 8:
			[textField setText:@"Pivot Joint"];
			demo = [[PivotJointConstraintDemo alloc] init];
			break;
		case 9:
			[textField setText:@"Gear Joint"];
			demo = [[GearJointConstraintDemo alloc] init];
			break;
		case 10:
			[textField setText:@"Poly Demo"];
			demo = [[PolyDemo alloc] init];
			break;
		case 11:
			[textField setText:@"Car Demo"];
			demo = [[CarDemo alloc] init];
			break;			
		case 12:
			[textField setText:@"Simple Collision Demo"];
			demo = [[SimpleCollisionDemo alloc] init];
			break;
		case 13:
			[textField setText:@"Sparrow Ball Demo"];
			demo = [[BallDemo alloc] init];
			break;
		case 14:
			[textField setText:@"Theo Jansen Demo"];
			demo = [[TheoJansenDemo alloc] init];
			break;
		case 15:
			[textField setText:@"Rope Demo"];
			demo = [[RopeDemo alloc] init];
			break;
		case 16:
			[textField setText:@"Newtons Cradle Demo"];
			demo = [[NewtonsCradleDemo alloc] init];
			break;
		case 17:
			[textField setText:@"Blocks Demo"];
			demo = [[BlocksDemo alloc] init];
			break;
		case 18:
			[textField setText:@"Many Blocks Demo"];
			demo = [[ManyBlocksDemo alloc] init];
			break;
	}
	
	[demo setHeight:480 - 5 - 32];
	
	[self addChild:demo];
	
	[demo startDemo];
}

- (void) dealloc {
	[previousDemo release];
	[nextDemo release];
	
	[super dealloc];
}

@end
