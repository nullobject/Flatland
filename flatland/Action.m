//
//  Action.m
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Action.h"

@implementation Action

- (id)initWithPlayer:(NSUUID *)uuid {
  if (self = [super init]) {
    _uuid = uuid;
  }

  return self;
}

@end

@implementation MoveAction

- (id)initWithPlayer:(NSUUID *)uuid andAmount:(CGFloat)amount {
  if (self = [super initWithPlayer:uuid]) {
    _amount = amount;
  }

  return self;
}

@end

@implementation TurnAction

- (id)initWithPlayer:(NSUUID *)uuid andAmount:(CGFloat)amount {
  if (self = [super initWithPlayer:uuid]) {
    _amount = amount;
  }

  return self;
}

@end
