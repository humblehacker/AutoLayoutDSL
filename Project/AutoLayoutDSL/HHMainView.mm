//
//  HHMainView
//
//  Created by david on 4/24/14.
//  Copyright (c) 2014 David Whetstone. All rights reserved.
//

#import "AutoLayoutDSL.h"
#import "KeyboardProxyView.h"
#import "HHMainView.h"


@interface HHMainView ()
@property (nonatomic, weak) KeyboardProxyView *keyboardProxyView;
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
    KeyboardProxyView *view = [[KeyboardProxyView alloc] init];
    view.layoutID = @"kbProxyView";

    [self addSubview:view];
    self.keyboardProxyView = view;
}

- (void)updateConstraints
{
    BeginConstraints

    View(self.contentView).top() == View().top();
    View(self.contentView).left() == View().left();
    View(self.contentView).right() == View().right();
    View(self.contentView).bottom() == View(self.keyboardProxyView).top();

    EndConstraints

    [super updateConstraints];
}

@end
