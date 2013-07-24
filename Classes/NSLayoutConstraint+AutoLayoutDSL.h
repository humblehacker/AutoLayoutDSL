//
//  NSLayoutConstraint+AutoLayoutDSL.h
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (AutoLayoutDSL)

- (UIView*)firstView;
- (UIView*)secondView;

- (void)install;
- (void)remove;

@end
