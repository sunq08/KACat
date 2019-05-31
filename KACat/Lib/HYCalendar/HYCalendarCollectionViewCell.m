//
//  HYCalendarCollectionViewCell.m
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#define HYSelectedColor [UIColor colorWithRed:0/255.0 green:200/255.0 blue:177/255.0 alpha:1.0]
#define HYMiddleColor   [UIColor colorWithRed:196.0/255 green:246.0/255 blue:240.0/255 alpha:1.0]
#define HYNormalColor   [UIColor whiteColor]

#import "HYCalendarCollectionViewCell.h"
@interface HYCalendarCollectionViewCell()

@end
@implementation HYCalendarCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.day = [[UILabel alloc]init];
        self.day.font = [UIFont systemFontOfSize:15];
        self.day.backgroundColor = [UIColor whiteColor];
        self.day.textAlignment = NSTextAlignmentCenter;
        self.day.textColor = [UIColor darkGrayColor];
        [self addSubview:self.day];
        
        self.status = [[UILabel alloc]init];
        self.status.font = [UIFont systemFontOfSize:8];
        self.status.textColor = [UIColor darkGrayColor];
        self.status.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.status];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    float width = rect.size.width;
    float height = rect.size.height;
    self.day.frame = CGRectMake(0, 0, width, height-1);
    self.status.frame = CGRectMake(0, height - 22, width, 17);
    
    //当形状为圆形时更换frame
    if (self.type == HYCalendarItemTypeRectAlone || self.type == HYCalendarItemTypeRectCollected) {
        CGRect rect = CGRectMake((CGRectGetWidth(self.day.frame) - 32) / 2.0, (CGRectGetHeight(self.day.frame) - 32) / 2.0, 32, 32);
        self.day.layer.cornerRadius = 16;
        self.day.layer.masksToBounds = YES;
        self.day.frame = rect;
    }
    
    self.day.layer.masksToBounds = YES;
}

- (void)reloadCellWithFirstDay:(NSArray *)firstDay andLastDay:(NSArray *)lastDay andCurrentDay:(NSArray *)currentDay{
    UIColor *selectedColor = HYSelectedColor;
    UIColor *normalColor = HYNormalColor;
    UIColor *middleColor = HYMiddleColor;
    
    //当前日期小于1,隐藏
    if ([currentDay[2] integerValue] > 0) {
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
    
    //当图形是圆形时状态标签换颜色
    self.status.textColor = self.type == HYCalendarItemTypeRectCollected || self.type == HYCalendarItemTypeRectAlone ? selectedColor : normalColor;
    
    self.day.layer.cornerRadius = 0;
    self.status.text = @"";
    if (firstDay.count == 0) {//数据中没有数据则颜色全部初始化
        self.day.backgroundColor = normalColor;
        self.day.textColor = [UIColor darkGrayColor];
    }else if (lastDay.count == 0) {//当只有一个出发时间时，等于当前时间则变色，否则初始颜色
        if ([firstDay isEqual:currentDay]) {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
        }else {
            self.day.backgroundColor = normalColor;
            self.day.textColor = [UIColor darkGrayColor];
        }
        self.day.layer.cornerRadius = 3;
    }else {//当出发和返回都是当前时间，说明两次点击同一个，否则出发和返回各不同，如果都不同则没状态表示
        if ([firstDay isEqual:currentDay]) {
            self.day.backgroundColor = selectedColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = ([lastDay isEqual:currentDay])?@"开始 结束":@"开始";
        }else {
            if ([lastDay isEqual:currentDay]) {
                self.day.backgroundColor = selectedColor;
                self.day.textColor = [UIColor whiteColor];
                self.status.text = @"结束";
            }else {
                self.day.backgroundColor = normalColor;
                self.day.textColor = [UIColor darkGrayColor];
            }
        }
        
        //当不需要连接色时返回
        if (self.type == HYCalendarItemTypeRectAlone || self.type == HYCalendarItemTypeSquartAlone) {
            return;
        }
        
        NSInteger currentTime = [currentDay[0] integerValue] * 12 + [currentDay[1] integerValue] * 31 + [currentDay[2] integerValue];
        NSInteger firstTime = [firstDay[0] integerValue] * 12 + [firstDay[1] integerValue] * 31 + [firstDay[2] integerValue];
        NSInteger lastTime = [lastDay[0] integerValue] * 12 + [lastDay[1] integerValue] * 31 + [lastDay[2] integerValue];
        
        //中间色的出现情况为当前时间在出发和返回时间之间
        if ((currentTime < firstTime && currentTime > lastTime) || (currentTime > firstTime && currentTime < lastTime)) {
            self.day.backgroundColor = middleColor;
            self.day.textColor = [UIColor whiteColor];
            self.status.text = @"";
        }
    }
    
    if([self judgeIsToday:currentDay]){
        self.day.textColor = [UIColor redColor];
    }
}

- (BOOL)judgeIsToday:(NSArray *)date{
    BOOL isToday = NO;
    
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* now = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags fromDate:now];
    // 获取各时间字段的数值
    if([date[0] integerValue] == comp.year && [date[1] integerValue] == comp.month && [date[2] integerValue] == comp.day){
        isToday = YES;
    }
    
    return isToday;
}

@end
