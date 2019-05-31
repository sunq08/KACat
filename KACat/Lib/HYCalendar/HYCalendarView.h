//
//  HYCalendarView.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/22.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCalendarCollectionReusableView.h"
#import "HYCalendarCollectionViewCell.h"

typedef NS_ENUM(NSInteger, HYCalendarChooseType) {
    HYCalendarChooseSingle = 10,//选择一个时间
    HYCalendarChooseDouble      //选择两个时间
};
@interface HYCalendarView : UIView

/**
 *  item的形状类型,方块/圆形，是否有链接色,默认为方形有连接色
 */
@property (nonatomic, assign) HYCalendarItemType itemType;
/**
 *  日历返回类型，单选/日期区间选择,默认为single
 */
@property (nonatomic, assign) HYCalendarChooseType chooseType;
/**
 *  选中回调
 */
@property (nonatomic, copy) void (^getTime)(NSString * firstDay, NSString * lastDay);
/**
 *  出发时间
 *  firstDay
 */
@property (nonatomic, strong) NSArray * firstDay;
/**
 *  返回时间
 *  lastDay
 */
@property (nonatomic, strong) NSArray * lastDay;
/**
 *  重置按钮的图片，可不填
 */
@property (nonatomic, strong) UIImage *resetImg;
/**
 *  主题颜色
 */
@property (nonatomic, strong) UIColor *mainC;
/**
 *  显示方法
 */
- (void)show;

@end
