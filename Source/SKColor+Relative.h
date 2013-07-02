//
//  SKColor+Relative.h
//  flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

// The SKColor+Relative category adds a bunch of methods to the SKColor class
// for calculating colour values relative to other colour values.
@interface SKColor (Relative)

// Returns a colour lightened by the given amount (between 0 and 1).
- (SKColor *)lighten:(CGFloat)amount;

// Returns a colour darkened by the given amount (between 0 and 1).
- (SKColor *)darken:(CGFloat)amount;

// Returns a colour desaturated by the given amount (between 0 and 1).
- (SKColor *)desaturate:(CGFloat)amount;

// Returns a colour saturated by the given amount (between 0 and 1).
- (SKColor *)saturate:(CGFloat)amount;

// Returns a colour with the given hex value.
+ (SKColor *)colorWithRGB:(NSUInteger)color;

@end
