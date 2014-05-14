//
//  ViewWithSizeAttribute.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_VIEWWITHSIZEATTRIBUTE_H__
#define __AUTOLAYOUTDSL_VIEWWITHSIZEATTRIBUTE_H__

#import <UIKit/UIKit.h>
#import "ViewWithAttribute.h"

namespace AutoLayoutDSL
{

class ConstraintBuilder;

class ViewWithSizeAttribute : public ViewWithAttribute
{
public:
    ViewWithSizeAttribute(UIView * const view, NSLayoutAttribute attribute);

    ConstraintBuilder operator == (const ViewWithSizeAttribute &);
    ConstraintBuilder operator == (CGFloat rhs);

    ConstraintBuilder operator <= (const ViewWithSizeAttribute &);
    ConstraintBuilder operator <= (CGFloat rhs);

    ConstraintBuilder operator >= (const ViewWithSizeAttribute &);
    ConstraintBuilder operator >= (CGFloat rhs);

    ViewWithSizeAttribute & operator *(CGFloat value);
    friend ViewWithSizeAttribute & operator *(CGFloat value, ViewWithSizeAttribute &&rhs);

    ViewWithSizeAttribute & operator /(CGFloat value);

    ViewWithSizeAttribute & operator +(CGFloat value);
    friend ViewWithSizeAttribute & operator +(CGFloat value, ViewWithSizeAttribute &&rhs);

    ViewWithSizeAttribute & operator -(CGFloat value);
    friend ViewWithSizeAttribute & operator -(CGFloat value, ViewWithSizeAttribute &&rhs);

    friend class ConstraintBuilder;
    friend class View;

private:
    ViewWithSizeAttribute();

    // Private to prevent accidental use in constraint declaration.
    // Must use operator ==() instead.
    ViewWithSizeAttribute & operator =(ViewWithSizeAttribute rhs);
};

} // namespace AutoLayoutDSL

#include "ConstraintBuilder.h"

#endif // __AUTOLAYOUTDSL_VIEWWITHSIZEATTRIBUTE__
