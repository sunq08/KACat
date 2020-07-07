//
//  THTextField.m
//  GYSA
//
//  Created by SunQ on 2019/8/26.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THTextField.h"
#import "THKitConfig.h"
@interface THTextField()

@end
@implementation THTextField
+ (instancetype)textField{
    return [[self alloc]init];
}
// 成为第一响应者时注册通知监听文本变化
- (BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    return [super becomeFirstResponder];
}

// 注销第一响应者时移除文本变化的通知, 以免影响其它对象.
- (BOOL)resignFirstResponder {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    return [super resignFirstResponder];
}

- (void)textFieldTextChanged:(NSNotification *)notification {
    if (!self.limitLength) {//字数限制
        return;
    }
    NSString *keyboardType = self.textInputMode.primaryLanguage;
    if ([keyboardType isEqualToString:@"zh-Hans"]) {//对简体中文做特殊处理>>>>高亮拼写问题
        UITextRange *range = self.markedTextRange;
        if (!range) {
            if (self.text.length > [self.limitLength intValue]) {
                self.text = [self.text substringToIndex:[self.limitLength intValue]];
                NSLog(@"已经是最大字数");
            }else {/*有高亮不做限制*/}
        }
    }else {
        if ([self.text length] > [self.limitLength intValue]) {
            self.text = [self.text substringToIndex:[self.limitLength intValue]];
            NSLog(@"已经是最大字数");
        }
    }
}

@end
