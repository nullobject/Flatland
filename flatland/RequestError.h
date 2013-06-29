//
//  RequestError.h
//  flatland
//
//  Created by Josh Bassett on 29/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Serializable.h"

extern NSString * const RequestErrorDomain;

// Request error codes.
enum {
  RequestErrorPlayerUUIDMissing,
  RequestErrorPlayerUUIDInvalid,
  RequestErrorJSONMalformed,
  RequestErrorOptionsInvalid
};

@interface RequestError : NSError <Serializable>
@end
