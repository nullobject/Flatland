//
//  NSBundle+InfoDictionaryKeyPath.m
//  Flatland
//
//  Created by Josh Bassett on 30/07/13.
//  Copyright (c) 2013 Ferocia. All rights reserved.
//

#import "NSBundle+InfoDictionaryKeyPath.h"

@implementation NSBundle (InfoDictionaryKeyPath)

- (id)objectForInfoDictionaryKeyPath:(NSString *)keyPath {
  NSArray *keys = [keyPath componentsSeparatedByString:@"."];
  NSDictionary *info = self.infoDictionary;
  id object = info;
  
  for (NSString *key in keys) {
    object = [object objectForKey:key];
  }
  
  return object;
}

@end
