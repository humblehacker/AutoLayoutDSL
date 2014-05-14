//
//  View.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_VIEW_H__
#define __AUTOLAYOUTDSL_VIEW_H__

#import <UIKit/UIKit.h>
#import "ViewWithLocationAttribute.h"
#import "ViewWithSizeAttribute.h"

namespace AutoLayoutDSL
{

class ConstraintBuilder;

class View
{
public:
    View();
    View(View const &rhs);
    View(UIView *view);
    View(View const &viewHolder, UIView *view);
    void swap(View &view) throw();

    ViewWithLocationAttribute left;
    ViewWithLocationAttribute centerX;
    ViewWithLocationAttribute right;
    ViewWithLocationAttribute leading;
    ViewWithLocationAttribute trailing;

    ViewWithLocationAttribute top;
    ViewWithLocationAttribute centerY;
    ViewWithLocationAttribute bottom;
    ViewWithLocationAttribute baseline;

    ViewWithSizeAttribute width;
    ViewWithSizeAttribute height;

    friend class ConstraintBuilder;

private:
    // Private to prevent accidental use in constraint declaration.
    // Must use operator ==() instead.
    View & operator =(View rhs);

    void setupAttributes();

private:
    __strong UIView *_view;
};

} // namespace AutoLayoutDSL

#include "ConstraintBuilder.h"

#endif // __AUTOLAYOUTDSL_VIEW__
