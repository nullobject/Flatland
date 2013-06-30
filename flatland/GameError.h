//
//  GameError.h
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"

extern NSString * const GameErrorDomain;

// Game error codes.
enum {
  GameErrorPlayerUUIDMissing,
  GameErrorPlayerUUIDInvalid,
  GameErrorJSONMalformed,
  GameErrorOptionsInvalid,
  GameErrorPlayerInsufficientEnergy
};

@interface GameError : NSError <Serializable>
@end
