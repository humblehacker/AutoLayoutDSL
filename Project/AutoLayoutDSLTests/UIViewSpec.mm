//
//  ConstraintSpec.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/19/13.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import "Kiwi.h"
#import "AutoLayoutDSL.h"
#import "UIView+AutoLayoutDSLSugar.h"

using namespace AutoLayoutDSL;


SPEC_BEGIN(UIViewSpec)

    describe(@"When searching for common ancestors", ^
    {
        describe(@"given two views without any common ancestors", ^
        {
            it(@"should return nil", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v2] should] beNil];
            });
        });

        describe(@"given the same view", ^
        {
            it(@"should return that view", ^
            {
                UIView *v1 = [UIView new];

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v1] should] equal:v1];
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

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v2] should] equal:parent];
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

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v2] should] equal:parent];
            });
        });

        describe(@"given two views where v1 is the parent of v2", ^
        {
            it(@"should return v1", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                [v1 addSubview:v2];

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v2] should] equal:v1];
            });
        });

        describe(@"given two views where v2 is the parent of v1", ^
        {
            it(@"should return v2", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                [v2 addSubview:v1];

                [[[UIView nearestCommonAncestorBetweenView:v1 andView:v2] should] equal:v2];
            });
        });
    });

    describe(@"calling -[UIView constraintWithID]", ^
    {
        describe(@"when no constraints exist with that ID", ^
        {
            it(@"should return nil", ^
            {
                UIView *v = [UIView new];
                [[[v constraintWithID:@"id"] should] beNil];
            });
        });

        describe(@"when multiple constraints exist with that ID", ^
        {
            it(@"should return the first matching constraint", ^
            {
                UIView *v = [UIView new];
                NSLayoutConstraint *c1 = View(v).height == 50.0 ^ @"constraint";
                NSLayoutConstraint *c2 = View(v).width == 30.0 ^ @"constraint";
                [c1 install];
                [c2 install];
                [[[v constraintWithID:@"constraint"] should] equal:c1];
            });
        });
    });

    describe(@"calling -[UIView constraintsWithID]", ^
    {
        describe(@"when no constraints exist with that ID", ^
        {
            it(@"should return an empty array", ^
            {
                UIView *v = [UIView new];
                NSLayoutConstraint *c = View(v).height == 50.0;
                [c install];
                [[[v constraintsWithID:@"id"] should] equal:@[]];
            });
        });

        describe(@"when multiple constraints exist with that ID", ^
        {
            it(@"should return the first matching constraint", ^
            {
                UIView *v = [UIView new];
                NSLayoutConstraint *c1 = View(v).height == 50.0 ^ @"constraint";
                NSLayoutConstraint *c2 = View(v).width == 30.0 ^ @"constraint";
                NSLayoutConstraint *c3 = View(v).left == View(v).right;
                [c1 install];
                [c2 install];
                [c3 install];

                NSArray *constraints = [v constraintsWithID:@"constraint"];

                [[constraints should] contain:c1];
                [[constraints should] contain:c2];
                [[constraints shouldNot] contain:c3];
            });
        });

        describe(@"when multiple constraints exist on this view and its ancestors", ^
        {
            it(@"should return an array with all and only the matching constraints", ^
            {
                UIView *v1 = [UIView new];
                UIView *v2 = [UIView new];
                UIView *v3 = [UIView new];
                [v3 addSubview:v2];
                [v2 addSubview:v1];
                NSLayoutConstraint *c1 = View(v1).height == 50.0 ^ @"constraint";
                NSLayoutConstraint *c2 = View(v3).width == 30.0 ^ @"constraint";
                NSLayoutConstraint *c3 = View(v3).left == View(v2).right;
                [c1 install];
                [c2 install];
                [c3 install];

                NSArray *constraints = [v1 constraintsWithID:@"constraint"];

                [[constraints should] contain:c1];
                [[constraints should] contain:c2];
                [[constraints shouldNot] contain:c3];
            });
        });
    });

    context(@"Specifying constraints with the UIView+AutoLayoutDSLSugar syntax", ^
    {
        it(@"should compile and run", ^
        {
            UIView *parent = [UIView new];
            UIView *v1 = [UIView new];
            UIView *v2 = [UIView new];

            [parent addSubview:v1];
            [parent addSubview:v2];

            v1.left == v2.right;
            v1.top == v2.bottom;
            v1.width == v2.height;
            v1.leading == v2.trailing;
            v1.centerX == v2.centerY;
            v1.baseline == v2.baseline;
        });
    });


    SPEC_END;
