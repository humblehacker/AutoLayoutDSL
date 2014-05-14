//
//  ViewWithAttribute
//  AutoLayoutDSL
//
//  Created by david on 5/12/14.
//  Copyright 2014 David Whetstone. All rights reserved.
//


#ifndef __ViewWithAttribute_H_
#define __ViewWithAttribute_H_

namespace AutoLayoutDSL
{

class ViewWithAttribute
{
public:
    ViewWithAttribute();
    ViewWithAttribute(ViewWithAttribute const &rhs);
    ViewWithAttribute(UIView const *view, NSLayoutAttribute attribute);

protected:
    void swap(ViewWithAttribute &view) throw();

    friend class ConstraintBuilder;

protected:
    UIView const *_view;
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

#endif //__ViewWithAttribute_H_
