//
//  ZHHDynamicTextViewHeightHandler.h
//  ZHHDynamicTextViewHeightHandler
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 一个 NSObject 的子类，用于在用户输入时动态调整 UITextView 的高度。
 当文本行数在指定的最小和最大行数之间时，UITextView 会自动调整大小。
 该类会计算 UITextView 文本的总高度，并更新其高度约束。
 使用时需要为 UITextView 提供高度约束。
 */

@interface ZHHDynamicTextViewHeightHandler : NSObject
/// UITextView 的引用
@property (nonatomic, strong) UITextView *growingTextView;
///// UITextView 的高度约束
//@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
///// 最大行数
//@property (nonatomic, assign) NSInteger maximumNumberOfLines;
///// 最小行数
//@property (nonatomic, assign) NSInteger minimumNumberOfLines;
/// 动画持续时间
@property (nonatomic, assign) CGFloat animationDuration;

/// 初始化方法
/// @param textView 需要调整大小的 UITextView
/// @param heightConstraint UITextView 的高度约束
- (instancetype)initWithTextView:(UITextView *)textView heightConstraint:(NSLayoutConstraint *)heightConstraint;

/// 更新最小和最大行数限制
/// @param minimumNumberOfLines 最小行数限制
/// @param maximumNumberOfLines 最大行数限制
- (void)zhh_updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines maximumNumberOfLine:(NSInteger)maximumNumberOfLines;

/// 根据文本内容调整 UITextView 的大小
/// @param animated 是否需要动画
- (void)zhh_resizeTextViewWithAnimation:(BOOL)animated;

/// 设置文本并调整 UITextView 的大小
/// @param text 新的文本
/// @param animated 是否需要动画
- (void)zhh_textViewWithValue:(NSString *)text animation:(BOOL)animated;

@end
