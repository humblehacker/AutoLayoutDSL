//
//  ViewWithAttribute
//  AutoLayoutDSL
//
//  Created by david on 5/12/14.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#include "ViewWithAttribute.h"
#import <algorithm>
#import "NSObject+AutoLayoutDSL.h"
#import "NSLayoutConstraint+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

ViewWithAttribute::ViewWithAttribute()
        : _view(nil), _attribute(NSLayoutAttributeNotAnAttribute), _scale(1.f), _offset(0.f)
{

}

ViewWithAttribute::ViewWithAttribute(UIView const *view, NSLayoutAttribute attribute)
        : _view(view), _attribute(attribute), _scale(1.f), _offset(0.f)
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

ViewWithAttribute::ViewWithAttribute(ViewWithAttribute const &rhs)
        : _view(rhs._view), _attribute(rhs._attribute), _scale(rhs._scale), _offset(rhs._offset)
{

}

void ViewWithAttribute::swap(ViewWithAttribute &view) throw()
{
    std::swap(_view, view._view);
    std::swap(_attribute, view._attribute);
    std::swap(_scale, view._scale);
    std::swap(_offset, view._offset);
}

NSString *ViewWithAttribute::str() const
{
    if (_attribute != NSLayoutAttributeNotAnAttribute)
        return [NSString stringWithFormat:@"%@%@%@%@", scaleStr(), viewStr(), attributeStr(), offsetStr()];

    return [NSString stringWithFormat:@"%.1f", _offset];
}

NSString *ViewWithAttribute::viewStr() const
{
    return _view.layoutID;
}

NSString *ViewWithAttribute::attributeStr() const
{
    return [NSString stringWithFormat:@".%@", NSStringFromNSLayoutAttribute(_attribute)];
}

NSString *ViewWithAttribute::offsetStr() const
{
    if (_offset < 0.0)
        return [NSString stringWithFormat:@" - %.1f", fabs(_offset)];
    if (_offset > 0.0)
        return [NSString stringWithFormat:@" + %.1f", _offset];
    return @"";
}

NSString *ViewWithAttribute::scaleStr() const
{
    return _scale > 1.0 ? [NSString stringWithFormat:@"%.1f*", _scale] : @"";
}

} // namespace AutoLayoutDSL

