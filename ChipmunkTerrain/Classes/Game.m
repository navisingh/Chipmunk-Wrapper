

#import "Game.h" 

@implementation Game

- (id)initWithWidth:(float)width height:(float)height{
    if (self = [super initWithWidth:width height:height]){	
		
		// Add a container in landscape mode
		SPSprite *mContents = [SPSprite sprite];
		mContents = [[SPSprite alloc] init];
		mContents.rotation = SP_D2R(90);
		mContents.x = 320;
		[self addChild:mContents];
		
		// Add the terrain bkg image
		SPImage *terrain = [SPImage imageWithContentsOfFile:@"terrain.png"];
		[mContents addChild:terrain];
		
		// Set up the physic space
		[self setupSpace];
		
		// Initialize physic objects
		[self initializeChipmunkObjects];
		
		// Turn on the debug draw
		debugDraw = [[SPDebugDraw alloc] initWithManager:mSpace];
		[self addChild:debugDraw];
		
		// Add the ability to move the objects
		mTouchBody = [[mSpace addBody] retain];
		[mTouchBody addToSpace];		
		[self addEventListener:@selector(force:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        // Add the loop that update the physic objects
		[self addEventListener:@selector(step:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME]; 
		
    }
    return self;
}


- (void)setupSpace{
	
	// Setup the chipmunk space.
	mSpace = [[CMSpace alloc] init];
	[mSpace setSleepTimeThreshhold:5.0f];
	[mSpace setIterations:25];
	
	// Set the gravity in landscape mode
	[mSpace setGravity:cpv(-9.8 * 10,0)];
	
	// Apply a window containment.
	[mSpace addWindowContainmentWithWidth:320 height:480 elasticity:0.0 friction:1.0];

}


- (void)initializeChipmunkObjects{
	
	// Create the ball body with its shape.
	CMBody *body = [mSpace addBodyWithMass:2.0 moment:INFINITY];
	[body setPositionUsingVect:cpv(300, 70)];
	[body addToSpace];	
	CMShape *shape = [body addCircleWithRadius:20.0f];
	[shape setElasticity:0.8];
	[shape setFriction:0.8];
	[shape addToSpace];

	// Get the heightfield from the image	
	myTerrainDataArray=[[NSMutableArray alloc] init];
	[self PixelTracker:@"terrain.png"];

	// Create the shapes to follow the terrain image
	CMBody *floorBody = [mSpace addStaticBody];
	[floorBody setName:@"floorBody"];
	cpVect myPreviousCPVect=cpv([[myTerrainDataArray objectAtIndex:0] integerValue],0);
	cpVect myCurrentCPVect;
	for(int x=1;x<=[myTerrainDataArray count]-1;x=x+10)
	{
		myCurrentCPVect = cpv([[myTerrainDataArray objectAtIndex:x] integerValue],x);
		CMSegmentShape *wall = [floorBody addSegmentFrom:myPreviousCPVect to:myCurrentCPVect radius:1];
		[wall setCollisionType:CM_WINDOW_CONTAINMENT_COLLISION_TYPE];
		[wall setElasticity:0.0];
		[wall setFriction:1.0];
		[wall addToSpace];
		myPreviousCPVect=myCurrentCPVect;
	}
	
	// we have to make sure we plot the last point since it might get skipped because of the increment!	
	myCurrentCPVect = cpv([[myTerrainDataArray objectAtIndex:[myTerrainDataArray count]-1] integerValue],[myTerrainDataArray count]-1);
	CMSegmentShape *wall = [floorBody addSegmentFrom:myPreviousCPVect to:myCurrentCPVect radius:1];
	[wall setCollisionType:CM_WINDOW_CONTAINMENT_COLLISION_TYPE];
	[wall setElasticity:0.0];
	[wall setFriction:1.0];
	[wall addToSpace];
		
}


- (void)force:(SPTouchEvent*)event{
	
	// Add a constraint on touch
	SPTouch *touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseBegan] anyObject];
	if (touch) {
		SPPoint *spPoint = [touch locationInSpace:self];
		
		mTouchShape = [mSpace queryFirstByPoint:spPoint];
		if (mTouchShape) {
			mTouchPoint = [spPoint toCpVect];
			mTouchLast = mTouchPoint;
			[mTouchBody setPositionUsingPoint:spPoint];
			
			CMBody *body = [mTouchShape body];
			
			mTouchJoint = [mTouchBody addPivotJointConstraintWithBody:body anchor1:cpvzero anchor2:cpBodyWorld2Local([body cpBody], mTouchPoint)];
			[mTouchJoint setMaxForce:50000.00f];
			[mTouchJoint setBiasCoef:0.15f];
			[mTouchJoint addToSpace];
		}
	}
	
	touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseMoved] anyObject];
	if (touch && mTouchJoint != nil) {
		SPPoint *spPoint = [touch locationInSpace:self];
		cpVect point = [spPoint toCpVect];
		mTouchPoint = point;
	}
	
	touch = [[event touchesWithTarget:self andPhase:SPTouchPhaseEnded] anyObject];
	if (touch && mTouchJoint != nil) {
		[[mTouchJoint firstBody] removeConstraint:mTouchJoint];
		mTouchJoint = nil;
	}
}


- (void)step:(SPEnterFrameEvent *)event{
	
	// Update physic objects
	if (mTouchJoint != nil) {
		cpVect newPoint = cpvlerp(mTouchLast, mTouchPoint, 0.25f);
		[mTouchBody setPositionUsingVect:newPoint];
		[mTouchBody setVelocity:cpvmult(cpvsub(newPoint, mTouchLast), 30.0f)];
		
		mTouchLast = newPoint;
	}	
	[mSpace step:1.0f / 15.0f];
	[mSpace updateShapes];
	
}


- (void)PixelTracker:(NSString*)myImageName{
	
	// Create an heightfield based on the first non transparent pixel of every column of pixel
	UIImage *myOtherImage=[UIImage imageNamed:myImageName];
	
	CGContextRef currentContext=[self initARGBBitmapContextFromImage:[myOtherImage CGImage]];
	
    size_t w = CGImageGetWidth([myOtherImage CGImage]);
	size_t h = CGImageGetHeight([myOtherImage CGImage]);
	CGRect rect = {{0,0},{w,h}}; 
	
	CGContextDrawImage(currentContext, rect, [myOtherImage CGImage]); 
	
	unsigned char *pixelData = CGBitmapContextGetData (currentContext); 
    if (pixelData != NULL) 
    { 
		unsigned char *alpha; 
		
		int myCurrentRow,myCurrentColumn;
		
		int myCurrentActualY=0;
		
		int myRowTotal=CGBitmapContextGetHeight(currentContext);
		int myColumnTotal=CGBitmapContextGetBytesPerRow(currentContext);
		
		
		for (myCurrentColumn = 0; myCurrentColumn <= myColumnTotal-1; myCurrentColumn += 4 )
		{ 
			//myCurrentActualX=(myCurrentColumn)/4;				
			for (myCurrentRow = 0; myCurrentRow <= myRowTotal-1; myCurrentRow += 1 )
			{
				myCurrentActualY=myCurrentRow;
				
				size_t index=(myCurrentRow*myColumnTotal)+myCurrentColumn;				
				alpha = pixelData + index;
				if (*alpha!=0)
				{
					[myTerrainDataArray addObject:[NSNumber numberWithInt:(h-myCurrentActualY)]]; 
					break;
				}				
			}
		}
		
	}
	
	UIGraphicsEndImageContext();	
	CGContextRelease(currentContext);	
}


- (CGContextRef) initARGBBitmapContextFromImage:(CGImageRef) inImage{
	
	CGContextRef    context = NULL;
	CGColorSpaceRef colorSpace;
	void *          bitmapData;
	int             bitmapByteCount;
	int             bitmapBytesPerRow;
	
	// Get image width, height. We'll use the entire image.
	size_t pixelsWide = CGImageGetWidth(inImage);
	size_t pixelsHigh = CGImageGetHeight(inImage);
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow   = (pixelsWide * 4);
	bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
	
	// Use the generic RGB color space.
	colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL){
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	bitmapData = malloc( bitmapByteCount );
	if (bitmapData == NULL){
		fprintf (stderr, "Memory not allocated!");
		CGColorSpaceRelease( colorSpace );
		return NULL;
	}
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits
	// per component. Regardless of what the source image format is
	// (CMYK, Grayscale, and so on) it will be converted over to the format
	// specified here by CGBitmapContextCreate.
	context = CGBitmapContextCreate (bitmapData,
									 pixelsWide,
									 pixelsHigh,
									 8,      // bits per component
									 bitmapBytesPerRow,
									 colorSpace,
									 kCGImageAlphaPremultipliedFirst);
	if (context == NULL){
		free (bitmapData);
		fprintf (stderr, "Context not created!");
	}
	
	// Make sure and release colorspace before returning
	CGColorSpaceRelease( colorSpace );
	
	return context;
}


@end
