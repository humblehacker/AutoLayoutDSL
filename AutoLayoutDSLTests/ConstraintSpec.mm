//
//  ConstraintSpec.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/19/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import "Kiwi.h"
#import "AutoLayoutDSL.h"
#import "NSObject+LayoutID.h"

using namespace AutoLayoutDSL;

@interface NSLayoutConstraint (Testing)
@end

@implementation NSLayoutConstraint (Testing)

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class])
        return NO;

    NSLayoutConstraint *rhs = object;

    return     self.firstItem == rhs.firstItem &&
              self.secondItem == rhs.secondItem &&
          self.firstAttribute == rhs.firstAttribute &&
         self.secondAttribute == rhs.secondAttribute &&
                self.constant == rhs.constant &&
              self.multiplier == rhs.multiplier &&
                self.priority == rhs.priority &&
                self.relation == rhs.relation &&
        self.shouldBeArchived == rhs.shouldBeArchived;
}

@end


SPEC_BEGIN(ConstraintSpec)

    describe(@"Every constraint", ^
    {
        it(@"must explicitly specify a view on at least one side", ^
        {
            BeginConstraints

            [[theBlock(^{ View() == View(); }) should] raise];

            EndConstraints;
        });
    });

    describe(@"A constraint with one explicit view", ^
    {
        __block UIView *superview;
        __block UIView *v1;

        beforeEach(^
        {
            v1 = [UIView new];
            superview = [UIView new];
            [superview addSubview:v1];
        });

        afterEach(^
        {
            v1 = nil;
            superview = nil;
        });

        describe(@"the explicit view", ^
        {
            it(@"must have a superview", ^
            {
                BeginConstraints

                [[theBlock(^{ View(v1).minY() == View().minY(); }) shouldNot] raise];

                [v1 removeFromSuperview];

                [[theBlock(^{ View(v1).minY() == View().minY(); }) should] raise];

                EndConstraints;
            });

            it(@"must have a superview (implicit view specified on rhs)", ^
            {
                BeginConstraints

                [[theBlock(^{ View().minY() == View(v1).minY(); }) shouldNot] raise];

                [v1 removeFromSuperview];

                [[theBlock(^{ View().minY() == View(v1).minY(); }) should] raise];

                EndConstraints;
           });
        });

        it(@"must have an view on the opposite side", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1).midY() == nil; }) should] raise];

            EndConstraints;
        });

        describe(@"the implicit view", ^
        {
            it(@"should map to the explicit view's superview", ^
            {
                BeginConstraints

                NSLayoutConstraint *constraint = View(v1).midY() == View().minY();

                [[constraint.secondItem should] equal:v1.superview];

                EndConstraints;
            });

            it(@"should map to the explicit view's superview, regardless of order", ^
            {
                BeginConstraints

                NSLayoutConstraint *constraint = View().midY() == View(v1).minY();

                [[constraint.firstItem should] equal:v1.superview];

                EndConstraints;
            });
        });
    });

    describe(@"A constraint between two views", ^
    {
        __block UIView *v1;
        __block UIView *v2;

        beforeAll(^
        {
            v1 = [UIView new];
            v2 = [UIView new];
        });

        it(@"must have attributes on boths sides", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1) == View(v2); }) should] raise];

            EndConstraints;
        });

        it(@"can have a constant on only one side", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1).left() + 5 == View(v2).right() + 6; }) should] raise];

            EndConstraints;
        });

        it(@"can have a multiplier on only one side", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1).left() * 5 == View(v2).right() * 6; }) should] raise];

            EndConstraints;
        });

        it(@"must have constants and multipliers on the same side", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1).left() * 5 == View(v2).right() + 6; }) should] raise];

            EndConstraints;
        });

        it(@"should be commutative", ^
        {
            BeginConstraints

            NSLayoutConstraint *constraint1 = View(v1).midX() == 2*View(v2).minX() + 5;
            NSLayoutConstraint *constraint2 = View(v2).minX() * 2 + 5 == View(v1).midX();
            [[constraint1 should] equal:constraint2];

            EndConstraints;
        });

        describe(@"with a common parent", ^
        {
            __block UIView *superview;

            beforeAll(^
            {
                superview = [UIView new];
                [superview addSubview:v1];
                [superview addSubview:v2];
            });

            it(@"should be installed in the common parent view", ^
            {
                BeginConstraints

                View(v1).midX() == View(v2).midX(), @"constraint1";

                EndConstraints;

                [[[superview.constraints.lastObject layoutID] should] equal:@"constraint1"];
            });
        });

        describe(@"when converted to an NSLayoutConstraint object", ^
        {
            it(@"should map minX() to NSLayoutAttributeLeft", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeLeft)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeLeft)];
            });

            it(@"should map left() to NSLayoutAttributeLeft", ^
            {
                NSLayoutConstraint *constraint = View(v1).left() == View(v2).left();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeLeft)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeLeft)];
            });

            it(@"should map midX() to NSLayoutAttributeCenterX", ^
            {
                NSLayoutConstraint *constraint = View(v1).midX() == View(v2).midX();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeCenterX)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeCenterX)];
            });

            it(@"should map centerX() to NSLayoutAttributeCenterX", ^
            {
                NSLayoutConstraint *constraint = View(v1).centerX() == View(v2).centerX();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeCenterX)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeCenterX)];
            });

            it(@"should map maxX() to NSLayoutAttributeRight", ^
            {
                NSLayoutConstraint *constraint = View(v1).maxX() == View(v2).maxX();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeRight)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeRight)];
            });

            it(@"should map right() to NSLayoutAttributeRight", ^
            {
                NSLayoutConstraint *constraint = View(v1).right() == View(v2).right();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeRight)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeRight)];
            });

            it(@"should map minY() to NSLayoutAttributeTop", ^
            {
                NSLayoutConstraint *constraint = View(v1).minY() == View(v2).minY();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeTop)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeTop)];
            });

            it(@"should map top() to NSLayoutAttributeTop", ^
            {
                NSLayoutConstraint *constraint = View(v1).top() == View(v2).top();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeTop)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeTop)];
            });

            it(@"should map midY() to NSLayoutAttributeCenterY", ^
            {
                NSLayoutConstraint *constraint = View(v1).midY() == View(v2).midY();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeCenterY)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeCenterY)];
            });

            it(@"should map centerY() to NSLayoutAttributeCenterY", ^
            {
                NSLayoutConstraint *constraint = View(v1).centerY() == View(v2).centerY();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeCenterY)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeCenterY)];
            });

            it(@"should map maxY() to NSLayoutAttributeBottom", ^
            {
                NSLayoutConstraint *constraint = View(v1).maxY() == View(v2).maxY();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeBottom)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeBottom)];
            });

            it(@"should map bottom() to NSLayoutAttributeBottom", ^
            {
                NSLayoutConstraint *constraint = View(v1).bottom() == View(v2).bottom();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeBottom)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeBottom)];
            });

            it(@"should map leading() to NSLayoutAttributeLeading", ^
            {
                NSLayoutConstraint *constraint = View(v1).leading() == View(v2).leading();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeLeading)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeLeading)];
            });

            it(@"should map trailing() to NSLayoutAttributeTrailing", ^
            {
                NSLayoutConstraint *constraint = View(v1).trailing() == View(v2).trailing();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeTrailing)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeTrailing)];
            });

            it(@"should map baseline() to NSLayoutAttributeBaseline", ^
            {
                NSLayoutConstraint *constraint = View(v1).baseline() == View(v2).baseline();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeBaseline)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeBaseline)];
            });

            it(@"should map baseline() to NSLayoutAttributeBaseline", ^
            {
                NSLayoutConstraint *constraint = View(v1).width() == View(v2).width();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeWidth)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeWidth)];
            });

            it(@"should map baseline() to NSLayoutAttributeBaseline", ^
            {
                NSLayoutConstraint *constraint = View(v1).height() == View(v2).height();
                [[theValue(constraint.firstAttribute) should] equal:theValue(NSLayoutAttributeHeight)];
                [[theValue(constraint.secondAttribute) should] equal:theValue(NSLayoutAttributeHeight)];
            });

            it(@"should map priority when specified", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX() ^ 500.0;
                [[theValue(constraint.priority) should] equal:theValue(500.0)];
            });

            it(@"should map layoutID when specified", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX() ^ @"constraintLayoutID";
                [[constraint.layoutID should] equal:@"constraintLayoutID"];
            });

            it(@"should map both priority and layoutID when specified together", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX() ^ @"constraintLayoutID" ^ 500.0;
                [[constraint.layoutID should] equal:@"constraintLayoutID"];
                [[theValue(constraint.priority) should] equal:theValue(500.0)];
            });

            it(@"should map both priority and layoutID when specified together, regardless of order", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX() ^ 500.0 ^ @"constraintLayoutID";
                [[constraint.layoutID should] equal:@"constraintLayoutID"];
                [[theValue(constraint.priority) should] equal:theValue(500.0)];
            });

            it(@"should map both priority and layoutID when specified together, even when constants and multipliers are present", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX() * 5.0 + 4.0 ^ 500.0 ^ @"constraintLayoutID";
                [[constraint.layoutID should] equal:@"constraintLayoutID"];
                [[theValue(constraint.priority) should] equal:theValue(500.0)];
            });

            it(@"should map an == relation to NSLayoutRelationEqual", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() == View(v2).minX();
                [[theValue(constraint.relation) should] equal:theValue(NSLayoutRelationEqual)];
            });

            it(@"should map a <= relation to NSLayoutRelationLessThanOrEqual", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() <= View(v2).minX();
                [[theValue(constraint.relation) should] equal:theValue(NSLayoutRelationLessThanOrEqual)];
            });

            it(@"should map a >= relation to NSLayoutRelationGreaterThanOrEqual", ^
            {
                NSLayoutConstraint *constraint = View(v1).minX() >= View(v2).minX();
                [[theValue(constraint.relation) should] equal:theValue(NSLayoutRelationGreaterThanOrEqual)];
            });
        });
    });

    describe(@"When searching for common ancestors", ^
    {
        describe(@"given two views without any common ancestors", ^
        {
            it(@"should return nil", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];

                [[Constraint::nearestCommonAncestor(v1, v2) should] beNil];
            });
        });

        describe(@"given the same view", ^
        {
            it(@"should return that view", ^
            {
                UIView *v1 = [UIView new];

                [[Constraint::nearestCommonAncestor(v1, v1) should] equal:v1];
            });
        });

        describe(@"given two views with a common parent", ^
        {
            it(@"should return the common parent", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                UIView *parent = [UIView new];
                [parent addSubview:v1];
                [parent addSubview:v2];

                [[Constraint::nearestCommonAncestor(v1, v2) should] equal:parent];
            });
        });

        describe(@"given two views with a common ancestor", ^
        {
            it(@"should return the common ancestor", ^
            {
                UIView *v1 = [UIView new];
                UIView *v11 = [UIView new];
                UIView *v111 = [UIView new];
                UIView *v2 = [UIView new];
                UIView *v22 = [UIView new];
                UIView *v222 = [UIView new];
                UIView *parent = [UIView new];
                [v11 addSubview:v1];
                [v111 addSubview:v11];
                [parent addSubview:v111];
                [v22 addSubview:v2];
                [v222 addSubview:v22];
                [parent addSubview:v222];

                [[Constraint::nearestCommonAncestor(v1, v2) should] equal:parent];
            });
        });

        describe(@"given two views where v1 is the parent of v2", ^
        {
            it(@"should return v1", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                [v1 addSubview:v2];

                [[Constraint::nearestCommonAncestor(v1, v2) should] equal:v1];
            });
        });

        describe(@"given two views where v2 is the parent of v1", ^
        {
            it(@"should return v2", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                [v2 addSubview:v1];

                [[Constraint::nearestCommonAncestor(v1, v2) should] equal:v2];
            });
        });
    });

SPEC_END;
