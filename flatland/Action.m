//
//  Action.m
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Action.h"

@implementation Action
@end

@implementation SpawnAction
@end

@implementation IdleAction
@end

@implementation MoveAction

- (id)initWithAmount:(CGFloat)amount {
  if (self = [super init]) {
    _amount = amount;
  }

  return self;
}

@end

@implementation TurnAction

- (id)initWithAmount:(CGFloat)amount {
  if (self = [super init]) {
    _amount = amount;
  }

  return self;
}

@end
