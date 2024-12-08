//
//  GrowingTextViewHandler.m
//  GrowingTextViewHandler-objc
//
//  Created by 桃色三岁 on 2022/9/30.
//  Copyright © 2022 桃色三岁. All rights reserved.
//

#import "ZHHDynamicTextViewHeightHandler.h"

static CGFloat kDefaultAnimationDuration = 0.25; // 默认动画持续时间
static NSInteger kMinimumNumberOfLines = 1;     // 默认最小行数
static NSInteger kMaximumNumberOfLines = INT_MAX; // 默认最大行数

@interface ZHHDynamicTextViewHeightHandler()
/// UITextView 的高度约束
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
/// 初始高度
@property (nonatomic, assign) CGFloat initialHeight;
/// 最大高度
@property (nonatomic, assign) CGFloat maximumHeight;
/// 最大行数
@property (nonatomic, assign) NSInteger maximumNumberOfLines;
/// 最小行数
@property (nonatomic, assign) NSInteger minimumNumberOfLines;
@end

@implementation ZHHDynamicTextViewHeightHandler

/// 返回一个 GrowingTextViewHandler 的实例
/// @param textView 需要调整大小的 UITextView
/// @param heightConstraint UITextView 的高度约束
- (id)initWithTextView:(UITextView *)textView heightConstraint:(NSLayoutConstraint *)heightConstraint {
    self = [super init];
    if (self) {
        self.growingTextView = textView;
        self.heightConstraint = heightConstraint;
        // 设置默认动画时间
        self.animationDuration = kDefaultAnimationDuration;
        [self zhh_updateMinimumNumberOfLines:kMinimumNumberOfLines maximumNumberOfLine:kMaximumNumberOfLines];
    }
    return self;
}


#pragma mark - Public Methods
/// 限制 UITextView 的大小调整在最小和最大行数之间
/// @param minimumNumberOfLines 最小行数限制
/// @param maximumNumberOfLines 最大行数限制
- (void)zhh_updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines maximumNumberOfLine:(NSInteger)maximumNumberOfLines {
    _minimumNumberOfLines = minimumNumberOfLines;
    _maximumNumberOfLines = maximumNumberOfLines;
    [self updateInitialHeightAndResize];
}

/// 根据文本内容调整 UITextView 的大小
/// @param animated 指定为 YES 表示需要动画调整大小，NO 表示不需要动画
- (void)zhh_resizeTextViewWithAnimation:(BOOL)animated {
    NSInteger textViewNumberOfLines = self.currentNumberOfLines;
    CGFloat verticalAlignmentConstant = 0.0;
    if (textViewNumberOfLines <= self.minimumNumberOfLines) {
        verticalAlignmentConstant = self.initialHeight;
    }else if ((textViewNumberOfLines > self.minimumNumberOfLines) && (textViewNumberOfLines <= self.maximumNumberOfLines)) {
        CGFloat currentHeight = [self currentHeight];
        verticalAlignmentConstant = (currentHeight > self.initialHeight) ? currentHeight : self.initialHeight;
    }else if (textViewNumberOfLines > self.maximumNumberOfLines){
        verticalAlignmentConstant = self.maximumHeight;
    }
    if (self.heightConstraint.constant != verticalAlignmentConstant) {
        [self updateVerticalAlignmentWithHeight:verticalAlignmentConstant animated:animated];
    }
    if (textViewNumberOfLines <= self.maximumNumberOfLines) {
        [self.growingTextView setContentOffset:CGPointZero animated:YES];
    }
}

#pragma mark - Private Helpers
/// 更新初始高度并调整 UITextView 大小
- (void)updateInitialHeightAndResize {
    self.initialHeight = [self estimatedInitialHeight];
    self.maximumHeight = [self estimatedMaximumHeight];
    [self zhh_resizeTextViewWithAnimation:NO];
}

/// 计算初始高度
- (CGFloat)estimatedInitialHeight {
    CGFloat totalHeight = [self caretHeight] * self.minimumNumberOfLines + self.growingTextView.textContainerInset.top + self.growingTextView.textContainerInset.bottom;
    return fmax(totalHeight,self.growingTextView.frame.size.height);
}

/// 计算最大高度
- (CGFloat)estimatedMaximumHeight {
    CGFloat totalHeight = [self caretHeight] * self.maximumNumberOfLines + self.growingTextView.textContainerInset.top + self.growingTextView.textContainerInset.bottom;
    return totalHeight;
}

/// 获取光标高度
- (CGFloat)caretHeight {
    return [self.growingTextView caretRectForPosition:self.growingTextView.selectedTextRange.end].size.height;
}

/// 当前文本内容的高度
- (CGFloat)currentHeight {
    CGFloat width = self.growingTextView.bounds.size.width - 2.0 * self.growingTextView.textContainer.lineFragmentPadding;
    CGRect boundingRect = [self.growingTextView.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                               attributes:@{NSFontAttributeName:self.growingTextView.font}
                                                                  context:nil];
    CGFloat heightByBoundingRect = CGRectGetHeight(boundingRect) + self.growingTextView.font.lineHeight;
    return MAX(heightByBoundingRect,self.growingTextView.contentSize.height);
}

/// 当前行数
- (NSInteger)currentNumberOfLines  {
    CGFloat caretHeight = [self.growingTextView caretRectForPosition:self.growingTextView.selectedTextRange.end].size.height;
    CGFloat totalHeight = [self currentHeight] + self.growingTextView.textContainerInset.top + self.growingTextView.textContainerInset.bottom;
    NSInteger numberOfLines = (totalHeight/caretHeight) - 1;
    return numberOfLines;
}

/// 更新高度并调整布局
/// @param height 新的高度
/// @param animated 是否需要动画
- (void)updateVerticalAlignmentWithHeight:(CGFloat)height animated:(BOOL)animated {
    self.heightConstraint.constant = height;

    if (animated) {
        [UIView animateWithDuration:self.animationDuration animations:^{
            [self.growingTextView.superview layoutIfNeeded];
        }];
    } else {
        [self.growingTextView.superview layoutIfNeeded];
    }
}

/// 设置文本并根据内容调整大小
/// @param text 新的文本
/// @param animated 是否需要动画
- (void)zhh_textViewWithValue:(NSString *)text animation:(BOOL)animated {
    self.growingTextView.text = text;
    if (text.length > 0) {
        [self zhh_resizeTextViewWithAnimation:animated];
    } else {
        [self updateVerticalAlignmentWithHeight:self.initialHeight animated:animated];
    }
}

@end
