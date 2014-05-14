//
//  ConstraintBuilder.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_CONSTRAINTBUILDER_H__
#define __AUTOLAYOUTDSL_CONSTRAINTBUILDER_H__

#import "View.h"
#import "Constants.h"

namespace AutoLayoutDSL
{

class ConstraintBuilder
{
public:
    ConstraintBuilder(ViewWithAttribute const &lhs, NSLayoutRelation relation, ViewWithAttribute const &rhs);
    ~ConstraintBuilder();

    operator NSLayoutConstraint *();
    ConstraintBuilder & operator ^(NSString *layoutID);
    ConstraintBuilder & operator ^(UILayoutPriority priority);
    ConstraintBuilder & operator ,(NSString *layoutID);
    ConstraintBuilder & operator ,(UILayoutPriority priority);

    void install();

    NSString *str() const;

private:
    ViewWithAttribute _firstView;
    ViewWithAttribute _secondView;
    NSLayoutRelation _relation;
    UILayoutPriority _priority;
    NSLayoutConstraint *_layoutConstraint;
    void applyConstraintGroupName();
};


} // namespace AutoLayoutDSL

#define BeginConstraints \
    _Pragma( "clang diagnostic push" ) \
    _Pragma( "clang diagnostic ignored \"-Wunused-value\" " ) \
    { \
        using namespace AutoLayoutDSL;

#define EndConstraints \
    } \
    _Pragma( "clang diagnostic pop");


#endif // __AUTOLAYOUTDSL_CONSTRAINTBUILDER_H__
