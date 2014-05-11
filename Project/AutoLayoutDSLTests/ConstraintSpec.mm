//
//  ConstraintSpec.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/19/13.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import "Kiwi.h"
#import "AutoLayoutDSL.h"
#import "NSObject+AutoLayoutDSL.h"

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

        describe(@"when installed", ^
        {
            __block NSLayoutConstraint *constraint;

            beforeEach(^
            {
                BeginConstraints

                constraint = View().minY() == View(v1).minY();
                [constraint install];

                EndConstraints;
            });

            it(@"should be installed to the explicit view's superview", ^
            {
                [[v1.superview.constraints.lastObject should] equal:constraint];
            });

            it(@"then removed, should be removed from the explicit view's superview", ^
            {
                [constraint remove];
                [[v1.superview.constraints should] beEmpty];
            });
        });

        it(@"must have a view or a constant on the opposite side", ^
        {
            BeginConstraints

            [[theBlock(^{ View(v1).midY() == nil; }) should] raise];
            [[theBlock(^{ View(v1).width() == 50.0; }) shouldNot] raise];

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
            __block NSLayoutConstraint *constraint;

            beforeAll(^
            {
                superview = [UIView new];
                [superview addSubview:v1];
                [superview addSubview:v2];

                BeginConstraints

                constraint = View(v1).midX() == View(v2).midX();
                [constraint install];

                EndConstraints;
            });

            it(@"should be installed in the common parent view", ^
            {
                [[superview.constraints.lastObject should] equal:constraint];
            });

            it(@"when removed, should be removed from the common parent view", ^
            {
                [constraint remove];
                [[superview.constraints should] beEmpty];
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

SPEC_END;
