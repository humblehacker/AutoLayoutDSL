//
//  Constraint.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <cassert>
#import <utility>
#import <set>
#import <BlocksKit/NSArray+BlocksKit.h>

#import "Constants.h"
#import "Constraint.h"
#import "NSObject+LayoutID.h"

using namespace std;

namespace AutoLayoutDSL
{

Constraint::Constraint(View const & lhs, NSLayoutRelation relation, View const & rhs)
    : _relation(relation), _priority(UILayoutPriorityRequired)
{
    NSCAssert(lhs._view || rhs._view, @"Invalid constraint specified: a UIView must be specified on at least one side of a constraint expression");

    const BOOL hasLeftScale   = lhs._scale  != 1.0;
    const BOOL hasRightScale  = rhs._scale  != 1.0;
    const BOOL hasLeftOffset  = lhs._offset != 0.0;
    const BOOL hasRightOffset = rhs._offset != 0.0;
    const BOOL hasLeftValues  = hasLeftOffset || hasLeftScale;
    const BOOL hasRightValues = hasRightOffset || hasRightScale;
    const BOOL hasNoValues    = !(hasRightValues || hasLeftValues);

    NSCAssert((hasLeftScale != hasRightScale)   || !hasLeftScale,  @"Invalid constraint specified: 'scale' can only be specified on one side of a constraint expression.\n%@", str());
    NSCAssert((hasLeftOffset != hasRightOffset) || !hasLeftOffset, @"Invalid constraint specified: 'offset' can only be specified on one side of a constraint expression.\n%@", str());
    NSCAssert((hasLeftValues != hasRightValues) || !hasLeftValues, @"Invalid constraint specified: 'offset' and 'scale' must be specified on the same side of a constraint expression.\n%@", str());

    if (hasRightValues || hasNoValues)
    {
        _firstView  = lhs;
        _secondView = rhs;
    }
    else
    {
        _firstView  = rhs;
        _secondView = lhs;

        // Flip sense of inequal relations
        if (_relation != NSLayoutRelationEqual)
            _relation = _relation == NSLayoutRelationGreaterThanOrEqual ? NSLayoutRelationLessThanOrEqual : NSLayoutRelationGreaterThanOrEqual;
    }

    if (!_firstView._view)
        _firstView._view = _secondView._view.superview;

    if (!_secondView._view)
    {
        BOOL secondViewHasAttribute = _secondView._attribute != NSLayoutAttributeNotAnAttribute;
        _secondView._view = secondViewHasAttribute ? _firstView._view.superview : nil;
        NSCAssert(_secondView._view || !secondViewHasAttribute, @"Invalid constraint specified: attribute specified without view. Check that your views are added into a view hierarchy before building constraints");
    }

    _layoutConstraint = [NSLayoutConstraint constraintWithItem:_firstView._view
                                                     attribute:_firstView._attribute
                                                     relatedBy:_relation
                                                        toItem:_secondView._view
                                                     attribute:_secondView._attribute
                                                    multiplier:_secondView._scale
                                                      constant:_secondView._offset];
}

Constraint::~Constraint()
{
    @try
    {
        if (_layoutConstraint)
            install();
    }
    @catch (NSException *e)
    {
        NSLog(@"Exception occurred attempting to install layout constraint: %@ %@", e, _layoutConstraint);
    }
    @catch(...)
    {
        NSLog(@"Unknown exception occurred attempting to install constraint %@", _layoutConstraint);
    }
}

Constraint::operator NSLayoutConstraint *()
{
    applyConstraintGroupName();

    // To prevent duplicate installations, we release the layout constraint object here
    // with the assumption that it has been used in a call to addConstraint: or addConstraints:
    NSLayoutConstraint * layoutConstraint = nil;
    std::swap(_layoutConstraint, layoutConstraint);
    return layoutConstraint;
}

UIView *Constraint::nearestCommonAncestor(UIView *view1, UIView *view2)
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

Constraint& Constraint::operator, (NSString *layoutID)
{
    _layoutConstraint.layoutID = layoutID;
    return *this;
}

Constraint& Constraint::operator, (UILayoutPriority priority)
{
    _priority = priority;
    _layoutConstraint.priority = priority;
    return *this;
}

Constraint& Constraint::operator ^(NSString *layoutID)
{
    _layoutConstraint.layoutID = layoutID;
    return *this;
}

Constraint& Constraint::operator ^(UILayoutPriority priority)
{
    _priority = priority;
    _layoutConstraint.priority = priority;
    return *this;
}

void Constraint::install()
{
    applyConstraintGroupName();

    // Handle Unary constraint
    bool isUnary = !_secondView._view;
    if (isUnary)
    {
        NSLog(@"Adding unary constraint to view:%@", _firstView._view);
        [_firstView._view addConstraint:_layoutConstraint];
        return;
    }

    UIView *nearestAncestor = Constraint::nearestCommonAncestor(_firstView._view, _secondView._view);
    NSCAssert(nearestAncestor, @"Error: Constraint cannot be installed. No common ancestor between items.");

    NSLog(@"Adding binary constraint to view:%@", nearestAncestor);
    [nearestAncestor addConstraint:_layoutConstraint];
}

void Constraint::applyConstraintGroupName()
{
    if (!_layoutConstraint.layoutID)
    {
        NSString *groupName = ConstraintGroup::groupName();
        _layoutConstraint.layoutID = groupName;
    }
}

NSString *Constraint::str() const
{
    return [NSString stringWithFormat:@"%@ %@ %@ (%.1f)",
                                      _firstView.str(),
                                      stringFromRelation(_relation),
                                      _secondView.str(),
                                      _priority];
}

NSMutableArray * ConstraintGroup::_groups;

ConstraintGroup::ConstraintGroup(NSString *groupName)
{
    ConstraintGroup::pushGroup(groupName);
}

ConstraintGroup::~ConstraintGroup()
{
    ConstraintGroup::popGroup();
}

void ConstraintGroup::operator =(VoidBlock block)
{
    block();
}

NSString *ConstraintGroup::groupName()
{
    return [_groups reduce:nil withBlock:^id(NSString *groupName, NSString *groupItem)
    {
        return groupName ? [groupName stringByAppendingFormat:@".%@", groupItem] : groupItem;
    }];
}

void ConstraintGroup::pushGroup(NSString *groupName)
{
    if (!_groups)
        _groups = [NSMutableArray new];

    [_groups addObject:groupName];
}

void ConstraintGroup::popGroup()
{
    [_groups removeLastObject];
}

} // namespace AutoLayoutDSL
