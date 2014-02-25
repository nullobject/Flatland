//
//  GameError.h
//  Flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "Serializable.h"

extern NSString * const GameErrorDomain;

// Game error codes.
enum {
  GameErrorPlayerUUIDMissing,
  GameErrorPlayerUUIDInvalid,
  GameErrorJSONMalformed,
  GameErrorOptionsInvalid,
  GameErrorPlayerNotSpawned,
  GameErrorPlayerAlreadySpawned,
  GameErrorPlayerInsufficientEnergy
};

@interface GameError : NSError <Serializable>
@end
