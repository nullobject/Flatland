//
//  PlayerRestAction.m
//  Flatland
//
//  Created by Josh Bassett on 17/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Core.h"
#import "Player.h"
#import "PlayerRestAction.h"

@implementation PlayerRestAction

- (NSString *)name {
  return @"rest";
}

- (CGFloat)cost {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  return super.cost * ABS(NORMALIZE(amount));
}

- (void)applyToPlayer:(Player *)player completion:(void (^)(void))block {
  CGFloat amount = [(NSNumber *)[self.options objectForKey:@"amount"] floatValue];
  NSTimeInterval duration = self.duration * ABS(NORMALIZE(amount));
  [player rest:duration completion:block];
}

@end
