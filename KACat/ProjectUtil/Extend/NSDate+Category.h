//
//  NSDate+Category.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/27.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)
/**  获取当前时间 YYYY-MM-dd HH:mm:ss */
+ (NSString *)currentTimeWithFormat:(NSString *)format;
/**  获取本月第一天 */
+ (NSString *)getMonthStartWithDateFormat:(NSString *)format;
/**  获取本周第一天 */
+ (NSString *)getWeekStartWithDateFormat:(NSString *)format;
/**  获取当前时间戳*/
+(NSInteger)getCurrentTimestampWithFormat:(NSString *)format;

/**  将时间戳转换成时间 */
+ (NSString *)timeStampIntoTime:(NSInteger)timer withDateFormat:(NSString *)format;
/**  时间字符串转时间戳*/
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime withDateFormat:(NSString *)format;

/** 通过时间字符串获取年、月、日*/
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time;

/** 比较两个日期大小*/
+ (NSInteger)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

//日期格式转字符串
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format;
/** 字符串转日期格式*/
+ (NSDate *)timeToDate:(NSString *)string withDateFormat:(NSString *)format;

@end
