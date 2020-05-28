//
//  THTextFieldPicker.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum THTextFiledPickerStyle {
    THTextFiledCommonPicker         = 0,        //select
    THTextFiledTimePicker           = 1,        //时间选择
}THTextFiledPickerStyle;
@interface THTextFieldPicker : UITextField
/** 快捷创建picker*/
+ (instancetype)creatTextFiledWithStyle:(THTextFiledPickerStyle)style;
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<NSDictionary *>  *pickerData;
/** 取值*/
@property (nonatomic, strong) NSString      *val;
/** 日期格式*/
@property (nonatomic, strong) NSString      *dateFormate;
@end

NS_ASSUME_NONNULL_END
