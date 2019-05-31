//
//  NSDate+Category.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/27.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "NSDate+Category.h"
#define TIME_ZONE [NSTimeZone timeZoneWithName:@"Asia/Beijing"]
//#define TIME_ZONE [NSTimeZone defaultTimeZone]
@implementation NSDate (Category)
#pragma mark - 获取当前时间
+ (NSString *)currentTimeWithFormat:(NSString *)format {
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:format];//这里去掉 具体时间 保留日期
    NSTimeZone* timeZone = TIME_ZONE;
    [formater setTimeZone:timeZone];
    NSString * curTime = [formater stringFromDate:curDate];
    
    return curTime;
}

#pragma mark - 获取本月第一天
+ (NSString *)getMonthStartWithDateFormat:(NSString *)format{
    NSDate* today = [[NSDate alloc] init];
    NSDate* beginningOfMonth = nil;
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    BOOL ok =[gregorian rangeOfUnit:NSCalendarUnitMonth startDate:&beginningOfMonth interval:nil forDate:today];
    return (ok)?[self dateToString:beginningOfMonth withDateFormat:format]:@"2018-01-01";
}
#pragma mark - 获取本周第一天
+ (NSString *)getWeekStartWithDateFormat:(NSString *)format{
    NSDate* today = [[NSDate alloc] init];
    NSDate* beginningOfWeek = nil;
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    BOOL ok =[gregorian rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&beginningOfWeek interval:nil forDate:today];
    return (ok)?[self dateToString:beginningOfWeek withDateFormat:format]:@"2018-01-01";
}

#pragma mark - 获取当前时间戳
+(NSInteger)getCurrentTimestampWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = TIME_ZONE;
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSInteger timeSp = [datenow timeIntervalSince1970];
    return timeSp;
}

#pragma mark - 将时间戳转换成时间
+ (NSString *)timeStampIntoTime:(NSInteger)timer withDateFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:format];
    /* 设置时区 */
    NSTimeZone *timeZone = TIME_ZONE;
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timer];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    return  dateString;
}

/** 时间字符串转时间戳*/
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime withDateFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = TIME_ZONE;
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}

#pragma mark - 通过时间字符串获取年、月、日
+ (NSArray *)getYearAndMonthAndDayFromTimeString:(NSString *)time {
    NSString *year = [time substringToIndex:4];
    NSString *month = [[time substringFromIndex:5] substringToIndex:2];
    NSString *day = [[time substringFromIndex:8] substringToIndex:2];
    
    return @[year,month,day];
}

#pragma mark - 比较两个日期大小
+ (NSInteger)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* startDate = [formatter dateFromString:oneDay]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger start = [[NSNumber numberWithDouble:[startDate timeIntervalSince1970]] integerValue];
    
    NSDate* endDate = [formatter dateFromString:anotherDay]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger end = [[NSNumber numberWithDouble:[endDate timeIntervalSince1970]] integerValue];
    
    if(start>end){
        return 1;
    } else if (start == end) {
        return 0;
    } else{
        return -1;
    }
}

#pragma mark - 日期格式转字符串
+ (NSString *)dateToString:(NSDate *)date withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone* timeZone = TIME_ZONE;
    [dateFormatter setTimeZone:timeZone];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

#pragma mark - 字符串转日期格式
+ (NSDate *)timeToDate:(NSString *)string withDateFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone* timeZone = TIME_ZONE;
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}
@end
