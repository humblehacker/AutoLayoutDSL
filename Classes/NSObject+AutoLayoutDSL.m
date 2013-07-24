//
//  NSObject+AutoLayoutDSL.m
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <BlocksKit/NSObject+AssociatedObjects.h>

static void * const kLayoutIDKey;

@implementation NSObject (AutoLayoutDSL)

- (void)setLayoutID:(NSString *)layoutID
{
  [self associateValue:layoutID withKey:&kLayoutIDKey];
}

- (NSString *)layoutID
{
  return [self associatedValueForKey:&kLayoutIDKey];
}

@end

