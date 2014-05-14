//
//  ViewWithLocationAttribute.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_VIEWWITHLOCATIONATTRIBUTE_H__
#define __AUTOLAYOUTDSL_VIEWWITHLOCATIONATTRIBUTE_H__

#import <UIKit/UIKit.h>
#import "ViewWithAttribute.h"

namespace AutoLayoutDSL
{

class ConstraintBuilder;

class ViewWithLocationAttribute : public ViewWithAttribute
{
public:
    ViewWithLocationAttribute(UIView *const view, NSLayoutAttribute attribute);

    ConstraintBuilder operator == (const ViewWithLocationAttribute &);
    ConstraintBuilder operator == (CGFloat rhs);

    ConstraintBuilder operator <= (const ViewWithLocationAttribute &);
    ConstraintBuilder operator <= (CGFloat rhs);

    ConstraintBuilder operator >= (const ViewWithLocationAttribute &);
    ConstraintBuilder operator >= (CGFloat rhs);

    ViewWithLocationAttribute & operator *(CGFloat value);
    friend ViewWithLocationAttribute & operator *(CGFloat value, ViewWithLocationAttribute &&rhs);

    ViewWithLocationAttribute & operator /(CGFloat value);

    ViewWithLocationAttribute & operator +(CGFloat value);
    friend ViewWithLocationAttribute & operator +(CGFloat value, ViewWithLocationAttribute &&rhs);

    ViewWithLocationAttribute & operator -(CGFloat value);
    friend ViewWithLocationAttribute & operator -(CGFloat value, ViewWithLocationAttribute &&rhs);

    friend class ConstraintBuilder;
    friend class View;

private:
    ViewWithLocationAttribute();

    // Private to prevent accidental use in constraint declaration.
    // Must use operator ==() instead.
    ViewWithLocationAttribute & operator =(ViewWithLocationAttribute rhs);
};

} // namespace AutoLayoutDSL

#include "ConstraintBuilder.h"

#endif // __AUTOLAYOUTDSL_VIEWWITHLOCATIONATTRIBUTE__
