//
//  NSLayoutConstraint+AutoLayoutDSL.h
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/20/13.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (AutoLayoutDSL)

- (UIView*)firstView;
- (UIView*)secondView;

- (void)install;
- (void)remove;

- (NSString*)equationString;

@end

#if defined(__cplusplus)
extern "C" {
#endif

NSString * NSStringFromNSLayoutAttribute(NSLayoutAttribute attribute);
NSString * NSStringFromNSLayoutRelation(NSLayoutRelation relation);

#if defined(__cplusplus)
}
#endif
