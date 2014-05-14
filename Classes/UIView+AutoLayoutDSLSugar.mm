//
//  UIView(AutoLayoutDSLSugar)
//  AutoLayoutDSL
//
//  Created by david on 5/13/14.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import "UIView+AutoLayoutDSL.h"
#import "UIView+AutoLayoutDSLSugar.h"


@implementation UIView (AutoLayoutDSLSugar)

- (AutoLayoutDSL::ViewWithLocationAttribute)left
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeLeft);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)right
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeRight);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)top
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeTop);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)bottom
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeBottom);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)centerX
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeCenterX);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)centerY
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeCenterY);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)leading
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeLeading);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)trailing
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeTrailing);
}

- (AutoLayoutDSL::ViewWithLocationAttribute)baseline
{
    return AutoLayoutDSL::ViewWithLocationAttribute(self, NSLayoutAttributeBaseline);
}

- (AutoLayoutDSL::ViewWithSizeAttribute)width
{
    return AutoLayoutDSL::ViewWithSizeAttribute(self, NSLayoutAttributeWidth);
}

- (AutoLayoutDSL::ViewWithSizeAttribute)height
{
    return AutoLayoutDSL::ViewWithSizeAttribute(self, NSLayoutAttributeHeight);
}

@end
