//
//  UIView+AutoLayoutDSL.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import "UIView+AutoLayoutDSL.h"
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"
#import "NSArray+BlocksKit.h"
#import <set>

@implementation UIView (AutoLayoutDSL)

+ (UIView *)nearestCommonAncestorBetweenView:(UIView *)view1 andView:(UIView *)view2
{
    if (view1 == view2)
        return view1;

    std::set<UIView*> view1views;

    // Walk from view1 up its ancestor chain to construct a set of
    // potential ancestors of view2.
    for (UIView *view = view1; view != nil; view = view.superview)
    {
        view1views.insert(view);
    }

    // Walk from view2 up its ancestor chain to see if there are
    // any views in common with view1 and its ancestors, returning
    // immediately if found.
    for (UIView *view = view2; view != nil; view = view.superview)
    {
        if (view1views.find(view) != view1views.end())
            return view;
    }

    return nil;
}

- (UIView *)nearestCommonAncestorWithView:(UIView*)view
{
    return [UIView nearestCommonAncestorBetweenView:self andView:view];
}

- (NSLayoutConstraint *)constraintWithID:(NSString *)layoutID
{
    if (!layoutID)
        return nil;

    for (UIView *view = self; view != nil; view = view.superview)
    {
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if ([constraint.layoutID isEqualToString:layoutID])
                return constraint;
        }
    }

    return nil;
}


- (NSArray *)constraintsWithID:(NSString *)layoutID
{
    if (!layoutID)
        return @[];

    NSMutableArray *constraints = [NSMutableArray array];

    for (UIView *view = self; view != nil; view = view.superview)
    {
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if ([constraint.layoutID isEqualToString:layoutID])
                [constraints addObject:constraint];
        }
    }

    return constraints;
}

- (NSArray *)constraintsReferencingView:(UIView *)targetView
{
    NSMutableArray *array = [NSMutableArray array];

    for (UIView *view = self; view != nil; view = view.superview)
    {
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if (![constraint.class isEqual:[NSLayoutConstraint class]])
                continue;

            if (targetView == constraint.firstView || view == constraint.secondView)
                [array addObject:constraint];
        }
    }

    return array;
}

@end
