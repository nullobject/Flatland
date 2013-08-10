//
//  Core.h
//  Flatland
//
//  Created by Josh Bassett on 27/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#define M_TAU 6.28318530717959 // 2*pi

// Clamps X between A and B (where A <= X <= B).
#define CLAMP(X, A, B) MAX(A, MIN(X, B))

// Clamps X between -1 and 1.
#define NORMALIZE(X) CLAMP(X, -1.0f, 1.0f)

// Calculates the cartesian distance to the point (X, Y).
#define DISTANCE(X, Y) sqrt(pow(X, 2.0f) + pow(Y, 2.0f))

// Returns a random floating point value.
#define RANDOM() (arc4random() / (float)(0xffffffffu))

// The assets are all facing Y down, so offset by PI/2 to get into X right facing. */
#define POLAR_ADJUST(THETA) (THETA + M_PI_2)

// Clamps THETA between -1 and 1.
#define NORMALIZE_ANGLE(THETA) NORMALIZE(THETA / M_TAU)

typedef enum : uint8_t {
  ColliderTypeNone   = 0,
  ColliderTypeWall   = 1,
  ColliderTypeEntity = 2,
  ColliderTypeBullet = 4
} ColliderType;

CGFloat AngleBetweenPoints(CGPoint a, CGPoint b);

CFDictionaryRef PointCreateDictionaryRepresentation(CGPoint point);
CFDictionaryRef VectorCreateDictionaryRepresentation(CGVector vector);

BOOL PointMakeWithDictionaryRepresentation(CFDictionaryRef dictionaryRef, CGPoint *point);
BOOL VectorMakeWithDictionaryRepresentation(CFDictionaryRef dictionaryRef, CGVector *vector);
