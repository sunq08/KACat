//
//  NSString+THFormPredicate.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (THFormPredicate)
/** 是否手机号*/
- (BOOL) th_isValidateCellPhone;
#pragma mark - 内容校验
/** 是否只有中文*/
- (BOOL) th_isOnlyChinese;

/** 限制只能输入数字*/
- (BOOL) th_isOnlyNumber;

/** 判断是否含有表情*/
- (BOOL) th_validateEmoji;

- (BOOL) th_isOnlyAZ09;
@end

NS_ASSUME_NONNULL_END
