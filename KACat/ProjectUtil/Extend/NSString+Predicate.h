//
//  NSString+Predicate.h
//  iOS-Category
//
//  Created by 庄BB的MacBook on 16/7/20.
//  Copyright © 2016年 BBFC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Predicate)
#pragma mark - 项目自定义正则
/** 判断是否为正确的用户名*/
- (BOOL)isValidateUserName;

/** 判断是否为正确的密码*/
- (BOOL)isValidatePassword;

/** 有效的电话号码*/
- (BOOL) isValidMobileNumber;

#pragma mark - 公共正则验证
/** 有效的真实姓名*/
- (BOOL) isValidRealName;

/** 有效的验证码(根据自家的验证码位数进行修改)*/
- (BOOL) isValidVerifyCode;

/** 有效的金额*/
- (BOOL) isValidPrice;

/** 有效的银行卡号*/
- (BOOL) isValidBankCardNumber;

/** 有效的邮箱*/
- (BOOL) isValidEmail;

/** 检测有效身份证 15位*/
- (BOOL) isValidIdentifyFifteen;

/** 检测有效身份证 18位*/
- (BOOL) isValidIdentifyEighteen;

#pragma mark - 内容校验
/** 是否只有中文*/
- (BOOL) isOnlyChinese;

/** 限制只能输入数字*/
- (BOOL) isOnlyNumber;

/** 判断是否含有表情*/
- (BOOL) validateEmoji;

@end
