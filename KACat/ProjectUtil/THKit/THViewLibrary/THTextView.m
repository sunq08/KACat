//
//  THTextView.m
//  THKitProject
//
//  Created by 孙强 on 2020/6/1.
//  Copyright © 2020 sunq. All rights reserved.
//

#import "THTextView.h"

CGFloat const kTHTextViewPlaceholderVerticalMargin = 8.0; ///< placeholder垂直方向边距
CGFloat const kTHTextViewPlaceholderHorizontalMargin = 6.0; ///< placeholder水平方向边距

@interface THTextView ()
@property (nonatomic, weak) UILabel *placeholderLabel; ///< placeholderLabel
@end
@implementation THTextView

#pragma mark - Super Methods
/*便利构造器创建FSTextView实例.*/
+ (instancetype)textView {
    return [[self alloc] init];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self layoutIfNeeded];
    }
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}

// 成为第一响应者时注册通知监听文本变化
- (BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    return [super becomeFirstResponder];
}

// 注销第一响应者时移除文本变化的通知, 以免影响其它的`UITextView`对象.
- (BOOL)resignFirstResponder {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    return [super resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)initialize {
    // 基本配置 (需判断是否在Storyboard中设置了值)
    if (_limitLength == 0 || _limitLength == NSNotFound) _limitLength = NSUIntegerMax;
    if (!_placeholderColor) _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
    
    // 基本设定 (需判断是否在Storyboard中设置了值)
    if (!self.backgroundColor) self.backgroundColor = [UIColor whiteColor];
    if (!self.font) self.font = [UIFont systemFontOfSize:15.f];
    
    // placeholderLabel
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.font = self.font;
    placeholderLabel.text = _placeholder ? : @""; // 可能在Storyboard中设置了Placeholder
    placeholderLabel.textColor = _placeholderColor;
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    
    // constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:kTHTextViewPlaceholderVerticalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:kTHTextViewPlaceholderHorizontalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-kTHTextViewPlaceholderHorizontalMargin*2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-kTHTextViewPlaceholderVerticalMargin*2]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - Getter
// SuperGetter
- (NSString *)text {
    NSString *currentText = [super text];
    return [currentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

#pragma mark - Setter
// SuperStter
- (void)setText:(NSString *)text {
    [super setText:text];
    _placeholderLabel.hidden = [@(text.length) boolValue];
    // 手动模拟触发通知
    NSNotification *notification = [NSNotification notificationWithName:UITextViewTextDidChangeNotification object:self];
    [self textDidChange:notification];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) return;
    _placeholder = [placeholder copy];
    if (_placeholder.length > 0) {
        _placeholderLabel.text = _placeholder;
    }
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (!placeholderColor) return;
    _placeholderColor = placeholderColor;
    _placeholderLabel.textColor = _placeholderColor;
}

- (void)setMaxLength:(NSUInteger)limitLength{
    _limitLength = limitLength;
}

#pragma mark - NSNotification
- (void)textDidChange:(NSNotification *)notification {
    // 当前编辑的不是当前`TextView`的话直接返回
    if (notification.object != self) return;
    
    // 根据字符数量显示或者隐藏placeholderLabel
    _placeholderLabel.hidden = [@(self.text.length) boolValue];
    
    // 禁止第一个字符输入空格或者换行
    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }
    
    if (_limitLength != NSUIntegerMax && _limitLength != 0) { // 只有当limitLength字段的值不为无穷大整型也不为0时才计算限制字符数.
        NSString    *toBeString    = self.text;
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position   = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > _limitLength) {
                self.text = [toBeString substringToIndex:_limitLength]; // 截取最大限制字符数.
            }
        }
    }
}

@end
