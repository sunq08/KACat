//
//  PK-ios
//
//  Created by peikua on 15/9/15.
//  Copyright (c) 2015年 peikua. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Category)

/** 电话号码中间4位*显示 */
+ (NSString*) getSecrectStringWithPhoneNumber:(NSString*)phoneNum;

/** 银行卡号中间8位*显示 */
+ (NSString*) getSecrectStringWithAccountNo:(NSString*)accountNo;

/** 后四位用*显示 */
+ (NSString*) getLastFourSecrectWithString:(NSString*)string;

/** 添加数字的千位符 */
+ (NSString*) countNumAndChangeformat:(NSString *)num;

/**  NSString转为NSNumber */
- (NSNumber*) toNumber;

/** 计算文字高度 */
- (CGFloat) heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width;

/** 计算文字宽度 */
- (CGFloat) widthWithFontSize:(CGFloat)fontSize height:(CGFloat)maxHeight;

/** 抹除小数末尾的0 */
- (NSString*) removeUnwantedZero;

/** 去掉前后空格 */
- (NSString*) trimmedString;

/**  千分位转换*/
+ (NSString *)positiveStringFormat:(NSString *)text;
/**  千分位转换*/
+ (NSString *)positiveCGFloatFormat:(CGFloat)text;

/** 截取字符串，判空，判断长度 */
+ (NSString *)subString:(NSString *)string length:(NSInteger)length;

/** 解决精度丢失问题 */
+ (NSString *)reviseString:(NSString *)str;

@end
