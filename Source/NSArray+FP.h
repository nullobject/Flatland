//
//  NSArray+FP.h
//  Flatland
//
//  Created by Josh Bassett on 22/06/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

typedef id(^MapBlock)(id);

@interface NSArray (FP)

// Maps the given block over the array.
- (NSArray *)map:(MapBlock)block;

// Returns the first element of the array.
- (id)head;

// Returns the array with the first element removed.
- (NSArray *)tail;

// Returns the element matching the predicate.
- (id)find:(BOOL (^)(id object, NSUInteger index, BOOL *stop))predicate;

@end
