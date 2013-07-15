//
//  SKColor+Relative.m
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "SKColor+Relative.h"

@implementation SKColor (Relative)

- (SKColor *)lighten:(CGFloat)amount {
  CGFloat h, s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
  return [SKColor colorWithHue:h
                    saturation:s
                    brightness:CLAMP(b + (b * amount), 0.0f, 1.0f)
                         alpha:a];
}

- (SKColor *)darken:(CGFloat)amount {
  CGFloat h, s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
  return [SKColor colorWithHue:h
                    saturation:s
                    brightness:CLAMP(b - (b * amount), 0.0f, 1.0f)
                         alpha:a];
}

- (SKColor *)desaturate:(CGFloat)amount {
  CGFloat h, s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
  return [SKColor colorWithHue:h
                    saturation:CLAMP(s - (s * amount), 0.0f, 1.0f)
                    brightness:b
                         alpha:a];
}

- (SKColor *)saturate:(CGFloat)amount {
  CGFloat h, s, b, a;
  [self getHue:&h saturation:&s brightness:&b alpha:&a];
  return [SKColor colorWithHue:h
                      saturation:CLAMP(s + (s * amount), 0.0f, 1.0f)
                      brightness:b
                           alpha:a];
}

+ (SKColor *)colorWithRGB:(NSUInteger)color {
  return [SKColor colorWithRed:((color >> 16) & 0xFF) / 255.0f
                         green:((color >>  8) & 0xFF) / 255.0f
                          blue:((color      ) & 0xFF) / 255.0f
                         alpha:1.0f];
}

@end
