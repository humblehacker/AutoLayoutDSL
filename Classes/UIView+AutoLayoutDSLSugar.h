//
//  UIView(AutoLayoutDSLSugar)
//  AutoLayoutDSL
//
//  Created by david on 5/13/14.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewWithLocationAttribute.h"
#import "ViewWithSizeAttribute.h"

@interface UIView (AutoLayoutDSLSugar)

// Sugar for defining constraints

@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute left;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute right;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute centerX;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute centerY;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute top;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute bottom;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute leading;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute trailing;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithLocationAttribute baseline;

@property (nonatomic, readonly) AutoLayoutDSL::ViewWithSizeAttribute height;
@property (nonatomic, readonly) AutoLayoutDSL::ViewWithSizeAttribute width;

@end
