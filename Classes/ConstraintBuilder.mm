//
//  ConstraintBuilder.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <cassert>
#import <utility>
#import <set>

#import "ConstraintBuilder.h"
#import "ConstraintGroup.h"
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

ConstraintBuilder::ConstraintBuilder(ViewWithAttribute const &lhs, NSLayoutRelation relation, ViewWithAttribute const &rhs)
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

ConstraintBuilder::~ConstraintBuilder()
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

ConstraintBuilder::operator NSLayoutConstraint *()
{
    applyConstraintGroupName();

    // To prevent duplicate installations, we release the layout constraint object here
    // with the assumption that it has been used in a call to addConstraint: or addConstraints:
    NSLayoutConstraint * layoutConstraint = nil;
    std::swap(_layoutConstraint, layoutConstraint);
    return layoutConstraint;
}

ConstraintBuilder& ConstraintBuilder::operator, (NSString *layoutID)
{
    _layoutConstraint.layoutID = layoutID;
    return *this;
}

ConstraintBuilder& ConstraintBuilder::operator, (UILayoutPriority priority)
{
    _priority = priority;
    _layoutConstraint.priority = priority;
    return *this;
}

ConstraintBuilder& ConstraintBuilder::operator ^(NSString *layoutID)
{
    _layoutConstraint.layoutID = layoutID;
    return *this;
}

ConstraintBuilder& ConstraintBuilder::operator ^(UILayoutPriority priority)
{
    _priority = priority;
    _layoutConstraint.priority = priority;
    return *this;
}

void ConstraintBuilder::install()
{
    applyConstraintGroupName();
    [_layoutConstraint install];
}

void ConstraintBuilder::applyConstraintGroupName()
{
    if (!_layoutConstraint.layoutID)
    {
        NSString *groupName = ConstraintGroup::groupName();
        _layoutConstraint.layoutID = groupName;
    }
}

NSString *ConstraintBuilder::str() const
{
    return [NSString stringWithFormat:@"%@ %@ %@ (%.1f)",
                                      _firstView.str(),
                                      NSStringFromNSLayoutRelation(_relation),
                                      _secondView.str(),
                                      _priority];
}

} // namespace AutoLayoutDSL
