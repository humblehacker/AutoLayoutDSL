//
//  View.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_VIEW_H__
#define __AUTOLAYOUTDSL_VIEW_H__

#import <UIKit/UIKit.h>

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

    ConstraintBuilder operator == (const View &);
    ConstraintBuilder operator == (CGFloat rhs);

    ConstraintBuilder operator <= (const View &);
    ConstraintBuilder operator <= (CGFloat rhs);

    ConstraintBuilder operator >= (const View &);
    ConstraintBuilder operator >= (CGFloat rhs);

    View & operator *(CGFloat value);
    friend View & operator *(CGFloat value, View &rhs);

    View & operator /(CGFloat value);

    View & operator +(CGFloat value);
    friend View & operator +(CGFloat value, View &rhs);

    View & operator -(CGFloat value);
    friend View & operator -(CGFloat value, View &rhs);

    View & left();
    View & centerX();
    View & right();
    View & minX();
    View & midX();
    View & maxX();
    View & width();
    View & leading();
    View & trailing();

    View & top();
    View & centerY();
    View & bottom();
    View & minY();
    View & midY();
    View & maxY();
    View & height();
    View & baseline();

    friend class ConstraintBuilder;

private:
    // Private to prevent accidental use in constraint declaration.
    // Must use operator ==() instead.
    View & operator =(View rhs);

private:
    __strong UIView *_view;
    NSLayoutAttribute _attribute;
    CGFloat _scale;
    CGFloat _offset;
    NSString *str() const;
    NSString *offsetStr() const;
    NSString *scaleStr() const;
    NSString *attributeStr() const;
    NSString *viewStr() const;
};

} // namespace AutoLayoutDSL

#include "ConstraintBuilder.h"

#endif // __AUTOLAYOUTDSL_VIEW__
