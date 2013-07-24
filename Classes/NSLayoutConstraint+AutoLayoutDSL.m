//
//  NSLayoutConstraint+AutoLayoutDSL.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import "NSLayoutConstraint+AutoLayoutDSL.h"
#import "UIView+AutoLayoutDSL.h"

@implementation NSLayoutConstraint (AutoLayoutDSL)

- (UIView *)firstView
{
    return nil;
}

- (UIView *)secondView
{
    return nil;
}

- (void)install
{
    // Handle Unary constraint
    bool isUnary = !self.secondItem;
    if (isUnary)
    {
        NSLog(@"Adding unary constraint to view:%@", self.firstItem);
        [self.firstItem addConstraint:self];
        return;
    }

    UIView *nearestAncestor = [UIView nearestCommonAncestorBetweenView:self.firstItem andView:self.secondItem];
    NSCAssert(nearestAncestor, @"Error: Constraint cannot be installed. No common ancestor between items.");

    NSLog(@"Adding binary constraint to view:%@", nearestAncestor);
    [nearestAncestor addConstraint:self];
}

- (void)remove
{
    if (![self.class isEqual:[NSLayoutConstraint class]])
    {
        NSLog(@"Error: Can only uninstall NSLayoutConstraint. %@ is an invalid class.", self.class.description);
        return;
    }

    BOOL isUnary = !self.secondItem;
    if (isUnary)
    {
        [self.firstItem removeConstraint:self];
        return;
    }

    UIView *nearestCommonAncestor = [self.firstView nearestCommonAncestorWithView:self.secondView];
    [nearestCommonAncestor removeConstraint:self];
}

@end
