//
//  SQTextField.h
//  TextFiledTest
//
//  Created by SunQ on 2017/5/5.
//  Copyright © 2017年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SQTextField;

typedef NS_ENUM(NSInteger, TEXTFIELD_TYPE){
    TEXTFIELD_TYPE_NONE               = 0,   //没有规则
    TEXTFIELD_TYPE_POS_NUMBER         = 1,   //仅可以输入非负整数
    TEXTFIELD_TYPE_DECIMAL            = 2,   //仅可以输入小数,小数点后两位
    TEXTFIELD_TYPE_ENGLISH_WORD       = 3,   //仅可以输入英文字母
    TEXTFIELD_TYPE_NUMBERE_ENGLISH    = 4,   //仅可以输入数字，英文字母
    TEXTFIELD_TYPE_CHINESE            = 5,   //仅可以中文
    TEXTFIELD_TYPE_NO_EMOJI           = 6,   //仅可输入非表情字符
};//输入内容类型，默认没有规则

/** 达到最大限制文字回调*/
typedef void(^TextFieldMaxHandler)(SQTextField *textfield);

@interface SQTextField : UITextField


#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger textfield_type;
#else
/** 限制类型 */
@property (nonatomic, assign) TEXTFIELD_TYPE textfield_type;
#endif

/** 最大限制文本长度 可在xib中进行设置，默认为无穷大(即不限制).*/
@property (nonatomic, assign) IBInspectable NSUInteger      maxLength;

@end
