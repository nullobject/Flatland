//
//  GameError.m
//  Flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "GameError.h"

@implementation GameError

NSString * const GameErrorDomain = @"co.gamedogs.flatland";

- (NSDictionary *)asJSON {
  return @{@"error": self.localizedDescription,
           @"code":  [NSNumber numberWithInteger:self.code]};
}

- (NSString *)localizedDescription {
  NSString *key = [self codeAsString:self.code];
  if (key)
    return NSLocalizedString(key, @"Localized description");
  else
    return [super localizedDescription];
}

- (NSString *)codeAsString:(NSInteger)code {
  switch (code) {
    case GameErrorPlayerUUIDMissing:        return @"GameErrorPlayerUUIDMissing";
    case GameErrorPlayerUUIDInvalid:        return @"GameErrorPlayerUUIDInvalid";
    case GameErrorJSONMalformed:            return @"GameErrorJSONMalformed";
    case GameErrorOptionsInvalid:           return @"GameErrorOptionsInvalid";
    case GameErrorPlayerNotSpawned:         return @"GameErrorPlayerNotSpawned";
    case GameErrorPlayerAlreadySpawned:     return @"GameErrorPlayerAlreadySpawned";
    case GameErrorPlayerInsufficientEnergy: return @"GameErrorPlayerInsufficientEnergy";
    default:                                return nil;
  }
}

@end
