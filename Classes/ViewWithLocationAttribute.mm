//
//  ViewWithLocationAttribute.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <algorithm>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewWithLocationAttribute.h"
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

ViewWithLocationAttribute::ViewWithLocationAttribute()
{
}

ViewWithLocationAttribute::ViewWithLocationAttribute(UIView *const view, NSLayoutAttribute attribute)
        : ViewWithAttribute(view, attribute)
{

}

ViewWithLocationAttribute &ViewWithLocationAttribute::operator = (ViewWithLocationAttribute rhs)
{
    rhs.swap(*this);
    return *this;
}

ConstraintBuilder ViewWithLocationAttribute::operator == (const ViewWithLocationAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, rhs);
}

ConstraintBuilder ViewWithLocationAttribute::operator == (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, ViewWithLocationAttribute() + rhs);
}

ConstraintBuilder ViewWithLocationAttribute::operator <= (const ViewWithLocationAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, rhs);
}

ConstraintBuilder ViewWithLocationAttribute::operator <= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, ViewWithLocationAttribute() + rhs);
}

ConstraintBuilder ViewWithLocationAttribute::operator >= (const ViewWithLocationAttribute &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, rhs);
}

ConstraintBuilder ViewWithLocationAttribute::operator >= (CGFloat rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, ViewWithLocationAttribute() + rhs);
}

ViewWithLocationAttribute & ViewWithLocationAttribute::operator *(CGFloat value)
{
    _scale *= value;
    return *this;
}

ViewWithLocationAttribute & operator *(CGFloat value, ViewWithLocationAttribute &&rhs)
{
    return rhs.operator*(value);
}

ViewWithLocationAttribute & ViewWithLocationAttribute::operator /(CGFloat value)
{
    return operator*(1.0f/value);
}

ViewWithLocationAttribute & ViewWithLocationAttribute::operator +(CGFloat value)
{
    _offset += value;
    return *this;
}

ViewWithLocationAttribute & operator +(CGFloat value, ViewWithLocationAttribute &&rhs)
{
    return rhs.operator+(value);
}

ViewWithLocationAttribute & ViewWithLocationAttribute::operator -(CGFloat value)
{
    return operator+(-value);
}

ViewWithLocationAttribute & operator -(CGFloat value, ViewWithLocationAttribute &&rhs)
{
    return rhs.operator-(value);
}

} // namespace AutoLayoutDSL

