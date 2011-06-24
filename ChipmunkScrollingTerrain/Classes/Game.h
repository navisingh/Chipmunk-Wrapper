

#import <Foundation/Foundation.h>
#include "SPDebugDraw.h"
#include "SHLine.h"


@interface Game : SPStage{
	
	SPDebugDraw *debugDraw;
	
	CMSpace *mSpace;
	
	CMBody *ballBody;
	CMBody *floorBody;

	cpVect mTouchPoint;
	cpVect mTouchLast;
	
	CMBody *mTouchBody;
	CMShape *mTouchShape;
	CMConstraint *mTouchJoint;
	
	NSMutableArray *myTerrainDataArray;
		
	SPSprite *mContents;
	SPSprite *scrollingMap;
	SPSprite *ball;
}

- (void)setupSpace;
- (void)initializeChipmunkObjects;
- (CGContextRef) initARGBBitmapContextFromImage:(CGImageRef) inImage;
- (void)PixelTracker:(NSString*)myImageName;

@end
