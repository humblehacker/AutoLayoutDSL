//
//  ViewWithSizeAttribute.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <algorithm>
#import "ViewWithSizeAttribute.h"
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

ViewWithSizeAttribute::ViewWithSizeAttribute()
{
}

ViewWithSizeAttribute::ViewWithSizeAttribute(UIView * const view, NSLayoutAttribute attribute)
        : ViewWithAttribute(view, attribute)
{
}

ViewWithSizeAttribute &ViewWithSizeAttribute::operator = (ViewWithSizeAttribute rhs)
{
    rhs.swap(*this);
    return *this;
}

ConstraintBuilder ViewWithSizeAttribute::operator == (const ViewWithSizeAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, rhs);
}

ConstraintBuilder ViewWithSizeAttribute::operator == (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, ViewWithSizeAttribute() + rhs);
}

ConstraintBuilder ViewWithSizeAttribute::operator <= (const ViewWithSizeAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, rhs);
}

ConstraintBuilder ViewWithSizeAttribute::operator <= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, ViewWithSizeAttribute() + rhs);
}

ConstraintBuilder ViewWithSizeAttribute::operator >= (const ViewWithSizeAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, rhs);
}

ConstraintBuilder ViewWithSizeAttribute::operator >= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, ViewWithSizeAttribute() + rhs);
}

ViewWithSizeAttribute & ViewWithSizeAttribute::operator *(CGFloat value)
{
    _scale *= value;
    return *this;
}

ViewWithSizeAttribute & operator *(CGFloat value, ViewWithSizeAttribute &rhs)
{
    return rhs.operator*(value);
}

ViewWithSizeAttribute & ViewWithSizeAttribute::operator /(CGFloat value)
{
    return operator*(1.0f/value);
}

ViewWithSizeAttribute & ViewWithSizeAttribute::operator +(CGFloat value)
{
    _offset += value;
    return *this;
}

ViewWithSizeAttribute & operator +(CGFloat value, ViewWithSizeAttribute &rhs)
{
    return rhs.operator+(value);
}

ViewWithSizeAttribute & ViewWithSizeAttribute::operator -(CGFloat value)
{
    return operator+(-value);
}

ViewWithSizeAttribute & operator -(CGFloat value, ViewWithSizeAttribute &rhs)
{
    return rhs.operator-(value);
}

} // namespace AutoLayoutDSL

