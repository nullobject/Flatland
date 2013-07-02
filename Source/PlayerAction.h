//
//  PlayerAction.h
//  Flatland
//
//  Created by Josh Bassett on 2/07/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : uint8_t {
  PlayerActionTypeSpawn,
  PlayerActionTypeIdle,
  PlayerActionTypeMove,
  PlayerActionTypeTurn
} PlayerActionType;

@interface PlayerAction : NSObject

@property (nonatomic, assign) PlayerActionType type;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, readonly) CGFloat cost;

- (id)initWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

+ (id)playerActionWithType:(PlayerActionType)type andOptions:(NSDictionary *)options;

@end
