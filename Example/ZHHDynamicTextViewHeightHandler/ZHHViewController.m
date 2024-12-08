//
//  ZHHViewController.m
//  ZHHDynamicTextViewHeightHandler
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHViewController.h"
#import <ZHHDynamicTextViewHeightHandler/ZHHDynamicTextViewHeightHandler.h>
//#import <Masonry//Masonry.h>

@interface ZHHViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *textViewHeightConstraint;
@property (nonatomic, strong) ZHHDynamicTextViewHeightHandler *handler;
@end

@implementation ZHHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 初始化 UITextView
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textView.layer.cornerRadius = 8;
    self.textView.delegate = self;
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.textView];

    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        [self.textView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.textView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        // 固定顶部
        [self.textView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100]
        // 从底部固定
//        [self.textView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-100]
    ]];
    
    // 添加高度约束
    self.textViewHeightConstraint = [self.textView.heightAnchor constraintEqualToConstant:40];
    self.textViewHeightConstraint.active = YES;

    // 初始化 ZHHDynamicTextViewHeightHandler
    self.handler = [[ZHHDynamicTextViewHeightHandler alloc] initWithTextView:self.textView heightConstraint:self.textViewHeightConstraint];
    [self.handler zhh_updateMinimumNumberOfLines:1 maximumNumberOfLine:INT_MAX];
    
    // 添加按钮
    [self setupButtons];
}

// 添加按钮的方法
- (void)setupButtons {
    UIButton *emptyTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [emptyTextButton setTitle:@"清空文本" forState:UIControlStateNormal];
    [emptyTextButton addTarget:self action:@selector(emptyText:) forControlEvents:UIControlEventTouchUpInside];
    emptyTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:emptyTextButton];
    
    UIButton *addTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addTextButton setTitle:@"添加文本" forState:UIControlStateNormal];
    [addTextButton addTarget:self action:@selector(addText:) forControlEvents:UIControlEventTouchUpInside];
    addTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:addTextButton];

    // 添加按钮的约束
    [NSLayoutConstraint activateConstraints:@[
        [emptyTextButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [emptyTextButton.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:16],
        
        [addTextButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [addTextButton.topAnchor constraintEqualToAnchor:self.textView.bottomAnchor constant:16],
    ]];
}


// 当文本变化时更新高度
- (void)textViewDidChange:(UITextView *)textView {
    [self.handler zhh_resizeTextViewWithAnimation:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (IBAction)emptyText:(id)sender {
    [self.handler zhh_textViewWithValue:nil animation:YES];
}

- (IBAction)addText:(id)sender {
    [self.handler zhh_textViewWithValue: @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
                              animation:YES];
}

@end
