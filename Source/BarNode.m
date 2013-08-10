//
//  BarNode.m
//  Flatland
//
//  Created by Josh Bassett on 11/08/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "BarNode.h"
#import "Core.h"

@implementation BarNode

- (void)setValue:(CGFloat)value {
  _value = CLAMP(value, 0.0f, 100.0f);
  self.path = [BarNode pathWithSize:_size value:_value];
}

- (BarNode *)initWithSize:(CGSize)size color:(SKColor *)color {
  if (self = [super init]) {
    _size = size;
    self.value = 100.0f;
    self.fillColor = color;
    self.strokeColor = [SKColor clearColor];
  }

  return self;
}

#pragma mark - Private

+ (CGPathRef)pathWithSize:(CGSize)size value:(CGFloat)value {
  CGRect rect = CGRectMake(-size.width / 2, -size.height / 2, size.width * (value / 100), size.height);
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, rect);
  return path;
}

@end
