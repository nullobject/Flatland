//
//  Core.m
//  Flatland
//
//  Created by Josh Bassett on 10/08/2013.
//  Copyright (c) 2013 Gamedogs. All rights reserved.
//

#include "Core.h"

CGFloat AngleBetweenPoints(CGPoint a, CGPoint b) {
  CGFloat dx = b.x - a.x;
  CGFloat dy = b.y - a.y;
  return atan2f(dy, dx);
}

CFDictionaryRef PointCreateDictionaryRepresentation(CGPoint point) {
  CFMutableDictionaryRef dictionaryRef = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);

  CFNumberRef xRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &point.x);
  CFNumberRef yRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &point.y);

  CFDictionarySetValue(dictionaryRef, CFSTR("x"), xRef);
  CFDictionarySetValue(dictionaryRef, CFSTR("y"), yRef);

  return dictionaryRef;
}

CFDictionaryRef VectorCreateDictionaryRepresentation(CGVector vector) {
  CFMutableDictionaryRef dictionaryRef = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);

  CFNumberRef xRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &vector.dx);
  CFNumberRef yRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberCGFloatType, &vector.dy);

  CFDictionarySetValue(dictionaryRef, CFSTR("x"), xRef);
  CFDictionarySetValue(dictionaryRef, CFSTR("y"), yRef);

  return dictionaryRef;
}

BOOL PointMakeWithDictionaryRepresentation(CFDictionaryRef dictionaryRef, CGPoint *point) {
  CGFloat x, y;

  CFNumberRef xRef = CFDictionaryGetValue(dictionaryRef, CFSTR("x"));
  CFNumberRef yRef = CFDictionaryGetValue(dictionaryRef, CFSTR("y"));

  CFNumberGetValue(xRef, kCFNumberCGFloatType, &x);
  CFNumberGetValue(yRef, kCFNumberCGFloatType, &y);

  point->x = x;
  point->y = y;

  return YES;
}

BOOL VectorMakeWithDictionaryRepresentation(CFDictionaryRef dictionaryRef, CGVector *vector) {
  CGFloat x, y;

  CFNumberRef xRef = CFDictionaryGetValue(dictionaryRef, CFSTR("x"));
  CFNumberRef yRef = CFDictionaryGetValue(dictionaryRef, CFSTR("y"));

  CFNumberGetValue(xRef, kCFNumberCGFloatType, &x);
  CFNumberGetValue(yRef, kCFNumberCGFloatType, &y);

  vector->dx = x;
  vector->dy = y;

  return YES;
}
