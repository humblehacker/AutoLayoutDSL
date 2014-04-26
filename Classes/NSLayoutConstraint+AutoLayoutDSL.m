//
//  NSLayoutConstraint+AutoLayoutDSL.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import "NSLayoutConstraint+AutoLayoutDSL.h"
#import "UIView+AutoLayoutDSL.h"
#import "NSObject+AutoLayoutDSL.h"

@implementation NSLayoutConstraint (AutoLayoutDSL)

- (UIView *)firstView
{
    NSAssert([self.firstItem isKindOfClass:[UIView class]], @"firstItem is not a view");
    return self.firstItem;
}

- (UIView *)secondView
{
    NSAssert(!self.secondItem || [self.secondItem isKindOfClass:[UIView class]], @"secondItem is not a view");
    return self.secondItem;
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

- (NSString *)equationString
{
    NSString *lhs = [NSString stringWithFormat:@"%@.%@", self.firstView.layoutID,
                              NSStringFromNSLayoutAttribute(self.firstAttribute)];

    NSString *rhs = @"";

    if (self.secondView)
    {
        rhs = [NSString stringWithFormat:@"%@.%@",
                                         self.secondView.layoutID,
                                         NSStringFromNSLayoutAttribute(self.secondAttribute)];
        if (self.multiplier != 1.0)
            rhs = [NSString stringWithFormat:@"%@ * %.1f", rhs, self.multiplier];
    }

    if (!self.secondView)
    {
        NSString *sign = self.constant < 0 ? @"-" : @"";
        rhs = [NSString stringWithFormat:@"%@%@%.1f", rhs, sign, fabs(self.constant)];
    }
    else if (self.constant != 0.0)
    {
        NSString *sign = self.constant < 0 ? @"-" : @"+";
        rhs = [NSString stringWithFormat:@"%@ %@ %.1f", rhs, sign, fabs(self.constant)];
    }

    NSString *relation = NSStringFromNSLayoutRelation(self.relation);

    NSString *s = [NSString stringWithFormat:@"%@ %@ %@", lhs, relation, rhs];
    if (self.priority != 1000.0)
        s = [s stringByAppendingFormat:@" ^ %.1f", self.priority];
    if (self.hasLayoutID)
        s = [s stringByAppendingFormat:@" ^ \"%@\"", self.layoutID];
    return s;
}

@end


NSString *NSStringFromNSLayoutAttribute(NSLayoutAttribute attribute)
{
    switch (attribute)
    {
        case NSLayoutAttributeLeft: return @"left";
        case NSLayoutAttributeRight: return @"right";
        case NSLayoutAttributeTop: return @"top";
        case NSLayoutAttributeBottom: return @"bottom";
        case NSLayoutAttributeLeading: return @"leading";
        case NSLayoutAttributeTrailing: return @"trailing";
        case NSLayoutAttributeWidth: return @"width";
        case NSLayoutAttributeHeight: return @"height";
        case NSLayoutAttributeCenterX: return @"centerX";
        case NSLayoutAttributeCenterY: return @"centerY";
        case NSLayoutAttributeBaseline: return @"baseline";
        case NSLayoutAttributeNotAnAttribute:
        default: return @"not-an-attribute";
    }
}

NSString *NSStringFromNSLayoutRelation(NSLayoutRelation relation)
{
    switch (relation)
    {
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationEqual: return @"==";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        default: return @"not-a-relation";
    }
}
