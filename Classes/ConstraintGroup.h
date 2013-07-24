//
//  ConstraintGroup
//  Tout
//
//  Created by david on 7/21/13.
//  Copyright (c) 2013 Tout Industries, Inc. All rights reserved.
//

#ifndef __AUTOLAYOUTDSL_CONSTRAINTGROUP_H__
#define __AUTOLAYOUTDSL_CONSTRAINTGROUP_H__

#import <Foundation/Foundation.h>

namespace AutoLayoutDSL
{

typedef void (^VoidBlock)(void);

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

#define BeginConstraintGroup(groupName) \
    ConstraintGroup((groupName)) = ^ \
    BeginConstraints

#define EndConstraintGroup \
    EndConstraints

#endif // __AUTOLAYOUTDSL_CONSTRAINTGROUP_H__
