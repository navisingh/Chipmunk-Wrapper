

#import <Foundation/Foundation.h>
#include "SPDebugDraw.h"

@interface Game : SPStage{
	
	SPDebugDraw *debugDraw;

	cpVect mTouchPoint;
	cpVect mTouchLast;

	CMSpace *mSpace;
	CMBody *mTouchBody;
	CMShape *mTouchShape;
	CMConstraint *mTouchJoint;
	
	NSMutableArray *myTerrainDataArray;
}

- (void)setupSpace;
- (void)initializeChipmunkObjects;
- (CGContextRef) initARGBBitmapContextFromImage:(CGImageRef) inImage;
- (void)PixelTracker:(NSString*)myImageName;

@end
