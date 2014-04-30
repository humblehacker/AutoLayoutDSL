//
//  HHKeyboardProxyView
//
//  Created by David Whetstone on 2014.04.20.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import <libextobjc/EXTScope.h>
#import "AutoLayoutDSL.h"
#import "HHKeyboardProxyView.h"


@interface HHKeyboardProxyView ()
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) id keyboardWillShowObserver;
@property (nonatomic, strong) id keyboardWillHideObserver;
@end

@implementation HHKeyboardProxyView

- (void)dealloc
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.keyboardWillShowObserver];
    [center removeObserver:self.keyboardWillHideObserver];
}

// Listen for keyboard
- (void)establishNotificationHandlers
{
    @weakify(self);

    // Listen for keyboard appearance
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    self.keyboardWillShowObserver = [center addObserverForName:UIKeyboardWillShowNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *n)
                                                    {
                                                        @strongify(self);
                                                        [self keyboardWillShow:n];
                                                    }];

    // Listen for keyboard exit
    self.keyboardWillHideObserver = [center addObserverForName:UIKeyboardWillHideNotification
                                                        object:nil
                                                         queue:[NSOperationQueue mainQueue]
                                                    usingBlock:^(NSNotification *n)
                                                    {
                                                        @strongify(self);
                                                        [self keyboardWillHide:n];
                                                    }];
}

- (void)keyboardWillHide:(NSNotification *)n
{
    // Reset to zero
    CGFloat duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.heightConstraint.constant = 0.0;
    [UIView animateWithDuration:duration animations:^ { [self.superview layoutIfNeeded]; }];
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // Fetch keyboard frame
    CGFloat duration = [n.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardEndFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardEndFrame = [self.superview convertRect:keyboardEndFrame fromView:self.window];

    // Adjust to window
    CGRect windowFrame = [self.superview convertRect:self.window.frame fromView:self.window];
    CGFloat heightOffset = (windowFrame.size.height - keyboardEndFrame.origin.y) - self.superview.frame.origin.y;

    // Update and animate height constraint
    self.heightConstraint.constant = heightOffset;
    [UIView animateWithDuration:duration animations:^ { [self.superview layoutIfNeeded]; }];
}

- (void)layoutView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    if (!self.superview)
        return;

    // Stretch sides and bottom to superview

    BeginConstraints

        View(self).minX() == View().minX();
        View(self).width() == View().width();
        View(self).maxY() == View().maxY();
        self.heightConstraint = View(self).height() == 0.0;
        [self.heightConstraint install];

    EndConstraints
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];

    [self layoutView];
    [self establishNotificationHandlers];
}

@end
