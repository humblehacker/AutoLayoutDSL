//
//  View.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <algorithm>
#import "View.h"

namespace AutoLayoutDSL
{

View::View() : _view(nil)
{
    setupAttributes();
}

void View::setupAttributes()
{
    left = ViewWithLocationAttribute(_view, NSLayoutAttributeLeft);
    right = ViewWithLocationAttribute(_view, NSLayoutAttributeRight);
    top = ViewWithLocationAttribute(_view, NSLayoutAttributeTop);
    bottom = ViewWithLocationAttribute(_view, NSLayoutAttributeBottom);
    centerX = ViewWithLocationAttribute(_view, NSLayoutAttributeCenterX);
    centerY = ViewWithLocationAttribute(_view, NSLayoutAttributeCenterY);
    leading = ViewWithLocationAttribute(_view, NSLayoutAttributeLeading);
    trailing = ViewWithLocationAttribute(_view, NSLayoutAttributeTrailing);
    baseline = ViewWithLocationAttribute(_view, NSLayoutAttributeBaseline);
    width = ViewWithSizeAttribute(_view, NSLayoutAttributeWidth);
    height = ViewWithSizeAttribute(_view, NSLayoutAttributeHeight);
}

View::View(View const &rhs) : _view(rhs._view)
{
    setupAttributes();
}

View::View(UIView *view) : _view(view)
{
    setupAttributes();
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

View::View(View const &viewHolder, UIView *view)
    : _view(view)
{
    setupAttributes();
}

View &View::operator = (View rhs)
{
    rhs.swap(*this);
    return *this;
}

void View::swap(View &view) throw()
{
    std::swap(_view, view._view);
}

} // namespace AutoLayoutDSL

