//
//  THDateFieldPicker.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,THDateFiledMode) {
    THDateFiledSecondMode = 0,//年月日,时分秒
    THDateFiledMinuteMode = 1,//年月日,时分
    THDateFiledHourMode   = 2,//年月日,时
    THDateFiledDayMode    = 3,//年月日
    THDateFiledMonthMode  = 4,//年月
    THDateFiledYearMode   = 5,//年
};
@interface THDateFieldPicker : UITextField
/**选择模式*/
@property (nonatomic, assign) THDateFiledMode pickerViewMode;

@end

NS_ASSUME_NONNULL_END
