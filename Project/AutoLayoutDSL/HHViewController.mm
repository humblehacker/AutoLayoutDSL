//
//  HHViewController.m
//  AutoLayoutDSL
//
//  Created by David Whetstone on 7/14/13.
//  Copyright (c) 2013 humblehacker.com. All rights reserved.
//

#import "HHViewController.h"
#import "AutoLayoutDSL.h"
#import "NSArray+BlocksKit.h"
#import "HHMainView.h"

@interface HHViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *blueView;
@property (nonatomic, weak) UIView *greenView;
@property (nonatomic, weak) UIView *contentView;
@end

@implementation HHViewController


- (void)loadView
{
    [super loadView];
    HHMainView *mainView = [[HHMainView alloc] init];
    mainView.layoutID = @"mainView";
    mainView.backgroundColor = [UIColor lightGrayColor];

    self.view = mainView;
    self.contentView = mainView.contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addTextView];
    [self addGreenView];
    [self addBlueView];

    [self updateViewConstraints];
}

- (void)addTextView
{
    UITextField *textField = [[UITextField alloc] init];
    textField.layoutID = @"textField";
    textField.text = @"tap here";
    textField.font = [UIFont systemFontOfSize:18.0];
    textField.layer.borderWidth = 1.0;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;

    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)addBlueView
{
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.layoutID = @"blueView";

    [self.contentView addSubview:blueView];
    self.blueView = blueView;
}

- (void)addGreenView
{
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    greenView.layoutID = @"greenView";

    [self.contentView addSubview:greenView];
    self.greenView = greenView;
}

- (void)updateViewConstraints
{
    //self.view removeA
    BeginConstraints

    View(self.textField).top() == View().top() + StandardMargin;
    View(self.textField).left() == View().left() + StandardMargin;
    View(self.textField).right() == View().right() - StandardMargin;
    View(self.textField).height() == StandardControlHeight;

    View(self.blueView).top() == View(self.textField).bottom() + StandardVerticalGap;
    View(self.blueView).left() == View().left() + StandardMargin;
    View(self.blueView).width() == View().width() / 2.0f - StandardHorizontalGap / 2.0f - StandardMargin;
    View(self.blueView).bottom() == View().bottom() - StandardMargin;

    View(self.greenView).top() == View(self.blueView).top();
    View(self.greenView).left() == View(self.blueView).right() + StandardHorizontalGap;
    View(self.greenView).right() == View().right() - StandardMargin;
    View(self.greenView).bottom() == View(self.blueView).bottom();

    EndConstraints

    [super updateViewConstraints];

    [self.view logAmbiguities];
    [self logAllConstraints];
}

- (void)logAllConstraints
{
    [self.view.allConstraints bk_each:^(NSLayoutConstraint *constraint)
    {
        NSLog(@"%@", [constraint equationString]);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
