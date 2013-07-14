//
//  Constraint.h
//
//  Created by David Whetstone on 2013.07.14.
//  Copyright 2013 David Whetstone. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_CONSTRAINT_H__
#define __AUTOLAYOUTDSL_CONSTRAINT_H__

#import "View.h"
#import "Constants.h"

namespace AutoLayoutDSL
{

class Constraint
{
public:
    Constraint(View const & lhs, NSLayoutRelation relation, View const & rhs);
    ~Constraint();

    operator NSLayoutConstraint *();
    Constraint & operator ^(NSString *layoutID);
    Constraint & operator ^(UILayoutPriority priority);
    Constraint & operator ,(NSString *layoutID);
    Constraint & operator ,(UILayoutPriority priority);

    void install();

    NSString *str() const;

    static UIView *nearestCommonAncestor(UIView *view1, UIView *view2);

private:
    View _firstView;
    View _secondView;
    NSLayoutRelation _relation;
    UILayoutPriority _priority;
    NSLayoutConstraint *_layoutConstraint;
    void applyConstraintGroupName();
};

class ConstraintGroup
{
public:
    explicit ConstraintGroup(NSString *groupName);
    ~ConstraintGroup();

    void operator = (VoidBlock block);

    static void pushGroup(NSString *groupName);
    static void popGroup();
    static NSString *groupName();

private:
    static NSMutableArray *_groups;
};

} // namespace AutoLayoutDSL

#define BeginConstraints \
    _Pragma( "clang diagnostic push" ) \
    _Pragma( "clang diagnostic ignored \"-Wunused-value\" " ) \
    {

#define EndConstraints \
    } \
    _Pragma( "clang diagnostic pop");


#define BeginConstraintGroup(groupName) \
    ConstraintGroup((groupName)) = ^ \
    BeginConstraints

#define EndConstraintGroup \
    EndConstraints

#endif // __AUTOLAYOUTDSL_CONSTRAINT_H__
