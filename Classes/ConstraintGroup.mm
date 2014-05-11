//
//  ConstraintGroup
//  AutoLayoutDSL
//
//  Created by david on 7/21/13.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import "ConstraintGroup.h"
#import "NSArray+BlocksKit.h"

namespace AutoLayoutDSL
{

NSMutableArray * ConstraintGroup::_groups;

ConstraintGroup::ConstraintGroup(NSString *groupName)
{
    ConstraintGroup::pushGroup(groupName);
}

ConstraintGroup::~ConstraintGroup()
{
    ConstraintGroup::popGroup();
}

void ConstraintGroup::operator =(VoidBlock block)
{
    block();
}

NSString *ConstraintGroup::groupName()
{
    return [_groups bk_reduce:nil withBlock:^id(NSString *groupName, NSString *groupItem)
    {
        return groupName ? [groupName stringByAppendingFormat:@".%@", groupItem] : groupItem;
    }];
}

void ConstraintGroup::pushGroup(NSString *groupName)
{
    if (!_groups)
        _groups = [NSMutableArray new];

    [_groups addObject:groupName];
}

void ConstraintGroup::popGroup()
{
    [_groups removeLastObject];
}

} // namespace AutoLayoutDSL
