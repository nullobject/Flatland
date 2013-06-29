//
//  RequestError.m
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import "RequestError.h"

@implementation RequestError

NSString * const RequestErrorDomain = @"co.gamedogs.flatland";

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
    case RequestErrorPlayerUUIDMissing: return @"RequestErrorPlayerUUIDMissing";
    case RequestErrorPlayerUUIDInvalid: return @"RequestErrorPlayerUUIDInvalid";
    case RequestErrorJSONMalformed:       return @"RequestErrorJSONMalformed";
    case RequestErrorOptionsInvalid:    return @"RequestErrorOptionsInvalid";
    default:                            return nil;
  }
}

@end
