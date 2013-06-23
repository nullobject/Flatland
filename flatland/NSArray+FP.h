//
//  NSArray+FP.h
//  johanna-ios
//
//  Created by Josh Bassett on 08/05/13.
//  Copyright (c) 2013 Ferocia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^MapBlock)(id);

@interface NSArray (FP)

// Maps the given block over the array.
- (NSArray *)map:(MapBlock)block;

// Returns the first element of the array.
- (id)head;

// Returns the array with the first element removed.
- (NSArray *)tail;

@end
