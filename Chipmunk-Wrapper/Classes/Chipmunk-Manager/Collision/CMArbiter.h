//
//  CMArbiter.h
//  ChipmunkWrapper
//
//  Created by Ronald Mathies on 1/25/11.
//  Copyright 2011 Sodeso. All rights reserved.
//

#import <Foundation/Foundation.h>

// --- Types ---------------------------------------------------------------------------------------

// --- Interface ---------------------------------------------------------------------------------------

/**
 * The CMArbiter is used for collision detection, this class can specify
 * more information about the collision itself.
 */
@interface CMArbiter : NSObject {

@private
	cpArbiter *mArbiter;
}

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/**
 * Creates a new arbiter based on the chipmunk arbiter.
 *
 * @param arbiter the Chipmunk arbiter.
 */
- (id)initWithCpArbiter:(cpArbiter*)arbiter;

///---------------------------------------------------------------------------------------
/// @name Operations
///---------------------------------------------------------------------------------------

/**
 * Returns the first shape.
 */
- (CMShape*)shapeA;

/**
 * Returns the second shape.
 */
- (CMShape*)shapeB;

/**
 * Set the new elasticity which will go into effect when this step is over.
 *
 * @param elasticity the elasticity.
 */
- (void)setElasticity:(float)elasticity;

/**
 * Set the new friction which will go into effect when this step is over.
 *
 * @param friction the friction.
 */
- (void)setFriction:(float)friction;

/**
 * Returns the number of contacts that occured in this collision.
 */
- (int)numberOfContacts;

/**
 * Flag indicating if the shapes (shapeA and shapeB) are swapped.
 */
- (BOOL)areShapesSwapped;

@end
