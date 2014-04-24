//
//  UIView+AutoLayoutDSL.h
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoLayoutDSL)

+ (UIView *)nearestCommonAncestorBetweenView:(UIView *)view1 andView:(UIView *)view2;
- (UIView *)nearestCommonAncestorWithView:(UIView *)view;

- (NSLayoutConstraint *)constraintWithID:(NSString *)layoutID;
- (NSArray*)constraintsWithID:(NSString *)layoutID;

- (NSArray *)constraintsReferencingView:(UIView *)targetView;

#ifdef DEBUG
- (void)logAmbiguities;
#endif

@end
