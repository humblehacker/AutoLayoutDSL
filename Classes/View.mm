//
//  View.mm
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "View.h"

#import "Constants.h"
#import "NSObject+AutoLayoutDSL.h"

namespace AutoLayoutDSL
{

View::View() : _attribute(NSLayoutAttributeNotAnAttribute), _view(nil), _scale(1.0), _offset(0.0)
{
}

View::View(View const &rhs) : _view(rhs._view), _attribute(rhs._attribute), _scale(rhs._scale), _offset(rhs._offset)
{
}

View::View(UIView *view) : _attribute(NSLayoutAttributeNotAnAttribute), _view(view), _scale(1.0), _offset(0.0)
{
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

View::View(View const &viewHolder, UIView *view)
    : _attribute(viewHolder._attribute), _view(view), _scale(viewHolder._scale), _offset(viewHolder._offset)
{
}

ConstraintBuilder View::operator == (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, rhs);
}

ConstraintBuilder View::operator == (float rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationEqual, View() + rhs);
}

ConstraintBuilder View::operator <= (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, rhs);
}

ConstraintBuilder View::operator <= (float rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationLessThanOrEqual, View() + rhs);
}

ConstraintBuilder View::operator >= (const View &rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, rhs);
}

ConstraintBuilder View::operator >= (float rhs)
{
    return ConstraintBuilder(*this, NSLayoutRelationGreaterThanOrEqual, View() + rhs);
}

View & View::operator *(float value)
{
    _scale *= value;
    return *this;
}

View & operator *(float value, View &rhs)
{
    return rhs.operator*(value);
}

View & View::operator /(float value)
{
    return operator*(1.0/value);
}

View & View::operator +(float value)
{
    _offset += value;
    return *this;
}

View & operator +(float value, View &rhs)
{
    return rhs.operator+(value);
}

View & View::operator -(float value)
{
    return operator+(-value);
}

View & operator -(float value, View &rhs)
{
    return rhs.operator-(value);
}

View & View::left()
{
    _attribute = NSLayoutAttributeLeft;
    return *this;
}

View & View::minX()
{
    return left();
}

View & View::midX()
{
    _attribute = NSLayoutAttributeCenterX;
    return *this;
}

View & View::centerX()
{
    _attribute = NSLayoutAttributeCenterX;
    return *this;
}

View & View::right()
{
    _attribute = NSLayoutAttributeRight;
    return *this;
}

View & View::maxX()
{
    return right();
}

View & View::width()
{
    _attribute = NSLayoutAttributeWidth;
    return *this;
}

View & View::leading()
{
    _attribute = NSLayoutAttributeLeading;
    return *this;
}

View & View::trailing()
{
    _attribute = NSLayoutAttributeTrailing;
    return *this;
}

View & View::top()
{
    _attribute = NSLayoutAttributeTop;
    return *this;
}

View & View::minY()
{
    return top();
}

View & View::midY()
{
    _attribute = NSLayoutAttributeCenterY;
    return *this;
}

View & View::centerY()
{
    _attribute = NSLayoutAttributeCenterY;
    return *this;
}

View & View::bottom()
{
    _attribute = NSLayoutAttributeBottom;
    return *this;
}

View & View::maxY()
{
    return bottom();
}

View & View::height()
{
    _attribute = NSLayoutAttributeHeight;
    return *this;
}

View& View::baseline()
{
    _attribute = NSLayoutAttributeBaseline;
    return *this;
}

NSString *View::str() const
{
    if (_attribute != NSLayoutAttributeNotAnAttribute)
        return [NSString stringWithFormat:@"%@%@%@%@", scaleStr(), viewStr(), attributeStr(), offsetStr()];

    return [NSString stringWithFormat:@"%.1f", _offset];
}

NSString *View::viewStr() const
{
    return _view.layoutID;
}

NSString *View::attributeStr() const
{
    return stringFromAttribute(_attribute);
}

NSString *View::offsetStr() const
{
    if (_offset < 0.0)
        return [NSString stringWithFormat:@" - %.1f", fabs(_offset)];
    if (_offset > 0.0)
        return [NSString stringWithFormat:@" + %.1f", _offset];
    return @"";
}

NSString *View::scaleStr() const
{
    return _scale > 1 ? [NSString stringWithFormat:@"%.1f*", _scale] : @"";
}

NSString *stringFromAttribute(NSLayoutAttribute attribute)
{
    NSString *attributeName;
    switch (attribute)
    {
        case NSLayoutAttributeLeft: attributeName = @"left"; break;
        case NSLayoutAttributeRight: attributeName = @"right"; break;
        case NSLayoutAttributeTop: attributeName = @"top"; break;
        case NSLayoutAttributeBottom: attributeName = @"bottom"; break;
        case NSLayoutAttributeLeading: attributeName = @"leading"; break;
        case NSLayoutAttributeTrailing: attributeName = @"trailing"; break;
        case NSLayoutAttributeWidth: attributeName = @"width"; break;
        case NSLayoutAttributeHeight: attributeName = @"height"; break;
        case NSLayoutAttributeCenterX: attributeName = @"centerX"; break;
        case NSLayoutAttributeCenterY: attributeName = @"centerY"; break;
        case NSLayoutAttributeBaseline: attributeName = @"baseline"; break;
        case NSLayoutAttributeNotAnAttribute:
        default: attributeName = @"not-an-attribute"; break;
    }

    return [NSString stringWithFormat:@".%@", attributeName];
}

NSString *stringFromRelation(NSLayoutRelation relation)
{
    switch (relation)
    {
        case NSLayoutRelationLessThanOrEqual: return @"<=";
        case NSLayoutRelationEqual: return @"==";
        case NSLayoutRelationGreaterThanOrEqual: return @">=";
        default: return @"not-a-relation";
    }
}

} // namespace AutoLayoutDSL

