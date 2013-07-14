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

class Constraint;

class View
{
public:
    View();
    View(View const &rhs);
    View(UIView *view);
    View(View const &viewHolder, UIView *view);

    Constraint operator == (const View &);
    Constraint operator == (float rhs);

    Constraint operator <= (const View &);
    Constraint operator <= (float rhs);

    Constraint operator >= (const View &);
    Constraint operator >= (float rhs);

    View & operator *(float value);
    friend View & operator *(float value, View &rhs);

    View & operator /(float value);

    View & operator +(float value);
    friend View & operator +(float value, View &rhs);

    View & operator -(float value);
    friend View & operator -(float value, View &rhs);

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

    friend class Constraint;

private:
    __strong UIView *_view;
    NSLayoutAttribute _attribute;
    float _scale;
    float _offset;
    NSString *str() const;
    NSString *offsetStr() const;
    NSString *scaleStr() const;
    NSString *attributeStr() const;
    NSString *viewStr() const;
};

NSString *stringFromAttribute(NSLayoutAttribute attribute);
NSString *stringFromRelation(NSLayoutRelation relation);

} // namespace AutoLayoutDSL

#include "Constraint.h"

#endif // __AUTOLAYOUTDSL_VIEW__
