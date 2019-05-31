//
//  SQTextField.m
//  TextFiledTest
//
//  Created by SunQ on 2017/5/5.
//  Copyright © 2017年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "SQTextField.h"

@interface SQTextField()

@property (nonatomic, strong)NSString *lastText;

@end

@implementation SQTextField
#pragma mark - Super Methods

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

- (BOOL)becomeFirstResponder {
    BOOL become = [super becomeFirstResponder];
    // 成为第一响应者时注册通知监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    // 注销第一响应者时移除文本变化的通知, 以免影响其它的对象.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    return resign;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)initialize {
    self.lastText  = @"";
    // 基本配置 (需判断是否在Storyboard中设置了值)
    if (_maxLength == 0 || _maxLength == NSNotFound) _maxLength = NSUIntegerMax;
}

- (UIViewController *)viewController {
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next)
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    } 
    return viewController;
}


#pragma mark - Setter
- (void)setTextfield_type:(TEXTFIELD_TYPE)textfield_type{
    _textfield_type = textfield_type;
    if (textfield_type == TEXTFIELD_TYPE_POS_NUMBER) {
        self.keyboardType = UIKeyboardTypeNumberPad;
    }
    if (textfield_type == TEXTFIELD_TYPE_DECIMAL) {
        self.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

#pragma mark - NSNotification
- (void)textDidChange:(NSNotification *)notification {
    // 当前编辑的不是当前`TextFiled`的话直接返回
    if (notification.object != self) return;
    
    // 禁止第一个字符输入空格或者换行
    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }
    
    //字符类型限制
    if(![self.text isEqualToString:@""]){
        BOOL validatePass;
        switch (self.textfield_type) {
            case 0: validatePass = YES;                                         break;
            case 1: validatePass = YES;                                         break;
            case 2: validatePass = [self validateDecimal:self.text];            break;
            case 3: validatePass = [self validateEnglishWord:self.text];        break;
            case 4: validatePass = [self validateNumberEnglish:self.text];      break;
            case 5: validatePass = [self validateChinese:self.text];            break;
            case 6: validatePass = ![self validateEmoji:self.text];              break;
            default: validatePass = YES;                                        break;
        }
        if(!validatePass){ self.text = self.lastText; }
    }
    
    //最大值验证
    if (_maxLength != NSUIntegerMax && _maxLength != 0) { // 只有当maxLength字段的值不为无穷大整型也不为0时才计算限制字符数.
        NSString    *toBeString    = self.text;
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position   = [self positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > _maxLength) {
                self.text = [toBeString substringToIndex:_maxLength]; // 截取最大限制字符数.
                NSLog(@"已达到最大限制字数");
            }
        }
    }
    
    self.lastText = self.text;
}

#pragma mark -正则
//正则基础方法
-(BOOL)validateBaseFunctionWithString:(NSString*) string Regex:(NSString*) regex {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:string];
}
//判断是否是非负小数
-(BOOL)validateDecimal:(NSString *)text {
    NSString *numberRegex = @"^[0-9]+[.]|[0-9]+([.][0-9]{0,2})?$";
    return [self validateBaseFunctionWithString:text Regex:numberRegex];
}
//判断是否为纯英文
-(BOOL)validateEnglishWord:(NSString *)text {
    NSString *regex = @"^[A-Za-z]+$";
    return [self validateBaseFunctionWithString:text Regex:regex];
}
//判断是否为数字，英文组合
-(BOOL)validateNumberEnglish:(NSString *)text {
    NSString *regex = @"^[A-Za-z0-9_]+$";
    return [self validateBaseFunctionWithString:text Regex:regex];
}
//判断是否为中文
-(BOOL)validateChinese:(NSString *)text {
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    return [self validateBaseFunctionWithString:text Regex:regex];
}
//判断是否含有表情
-(BOOL)validateEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}

@end
