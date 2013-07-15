//
//  WorldNode.m
//  Flatland
//
//  Created by Josh Bassett on 15/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "WorldNode.h"

@implementation WorldNode

- (WorldNode *)initWithWorld:(World *)world {
  if (self = [super init]) {
    _world = world;
  }

  return self;
}

@end
