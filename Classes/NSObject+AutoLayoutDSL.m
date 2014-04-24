//
//  NSObject+AutoLayoutDSL.m
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <BlocksKit/NSObject+BKAssociatedObjects.h>

static void * const kLayoutIDKey;

@implementation NSObject (AutoLayoutDSL)

- (void)setLayoutID:(NSString *)layoutID
{
  [self bk_associateValue:layoutID withKey:&kLayoutIDKey];
}

- (NSString *)layoutID
{
    NSString *label = [self bk_associatedValueForKey:&kLayoutIDKey];
    if (!label)
        label = [NSString stringWithFormat:@"<%@:%tx>", NSStringFromClass([self class]), self];
    return label;
}

@end

