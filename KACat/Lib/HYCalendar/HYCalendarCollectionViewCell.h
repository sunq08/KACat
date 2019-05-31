
//
//  HYCalendarCollectionViewCell.h
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger, HYCalendarItemType) {
    HYCalendarItemTypeSquartAlone = 1,//方形没有连接色
    HYCalendarItemTypeSquartCollected,//方形有连接色
    HYCalendarItemTypeRectAlone,//圆形没有连接色
    HYCalendarItemTypeRectCollected//圆形有连接色
};

@interface HYCalendarCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) HYCalendarItemType type;

@property (strong, nonatomic) UILabel *day;
@property (strong, nonatomic) UILabel *status;

/**参数1:开始时间,参数2:结束时间,参数3:当前cell时间,参数4:cell的形状类型,参数5-7:cell的颜色*/
- (void)reloadCellWithFirstDay:(NSArray *)firstDay andLastDay:(NSArray *)lastDay andCurrentDay:(NSArray *)currentDay;

@end
