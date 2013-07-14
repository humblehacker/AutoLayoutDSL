//
//  AutoLayoutDSL.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_H__
#define __AUTOLAYOUTDSL_H__

/*  A simple C++ DSL to more concisely define layout constraints.

    Formerly, to specify the x offset of one button relative to another, with a
    5 point gap between them, one would write:

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_button1
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:_button2
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:5.0]];

    With the layout DSL, this would simply be written as:

        View(_button1).left() = View(_button2).right() + 5.0;
*/

#include "Constraint.h"
#include "View.h"

#endif // __AUTOLAYOUTDSL_H__
