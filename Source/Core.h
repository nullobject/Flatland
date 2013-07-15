//
//  Core.h
//  Flatland
//
//  Created by Josh Bassett on 27/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

// Clamps X between A and B (where a <= n <= b).
#define CLAMP(X, A, B) MAX(A, MIN(X, B))

// Clamps X between -1 and 1.
#define NORMALIZE(X) CLAMP(X, -1.0f, 1.0f)

// Calculates the cartesian distance to the point (X, Y).
#define DISTANCE(X, Y) sqrt(pow(X, 2.0f) + pow(Y, 2.0f))

// Returns a random floating point value.
#define RANDOM() (arc4random() / (float)(0xffffffffu))

#define M_TAU 6.28318530717959 // 2*pi

typedef enum : uint8_t {
  ColliderTypeNone   = 0,
  ColliderTypeWall   = 1,
  ColliderTypeEntity = 2,
  ColliderTypeBullet = 4
} ColliderType;
