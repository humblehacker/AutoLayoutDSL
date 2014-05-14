//
//  HHMainView
//
//  Created by david on 4/24/14.
//  Copyright 2014 David Whetstone. All rights reserved.
//

#import "AutoLayoutDSL.h"
#import "UIView+AutoLayoutDSLSugar.h"
#import "HHKeyboardProxyView.h"
#import "HHMainView.h"


@interface HHMainView ()
@property (nonatomic, weak) HHKeyboardProxyView *keyboardProxyView;
@property (nonatomic, weak) UIView *contentView;
@end

@implementation HHMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addContentView];
        [self addKeyboardProxyView];
        [self updateConstraints];
    }

    return self;
}

- (void)addContentView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.layoutID = @"contentView";

    [self addSubview:contentView];
    self.contentView = contentView;
}

- (void)addKeyboardProxyView
{
    HHKeyboardProxyView *view = [[HHKeyboardProxyView alloc] init];
    view.layoutID = @"kbProxyView";

    [self addSubview:view];
    self.keyboardProxyView = view;
}

- (void)updateConstraints
{
    BeginConstraints

    self.contentView.top == View().top;
    self.contentView.left == View().left;
    self.contentView.right == View().right;
    self.contentView.bottom == self.keyboardProxyView.top;

    EndConstraints

    [super updateConstraints];
}

@end
