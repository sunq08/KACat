//
//  THFormTextM.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormBaseM.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger,THFormTextValidType) {
    THFormTextValidNone             = 0,        //不校验，默认
    THFormTextValidCellPhone        = 1 << 0,   //电话
    THFormTextValidNumber           = 1 << 1,   //纯数字
    THFormTextValidNoEmoji          = 1 << 2,   //禁止表情
    THFormTextValidAZ09             = 1 << 3,   //只能英文字母及数字
};

///<点击事件block实现后，点击textfile响应事件
typedef void(^ClickActionBlock)(NSString *identifier);
@interface THFormTextM : THFormBaseM
@property (nonatomic, assign) BOOL isTextArea;
/** 校验，详见枚举*/
@property (nonatomic, assign) THFormTextValidType  validType;
/** 需要限制的字数*/
@property (nonatomic,  copy) NSNumber *limitLength;
/**键盘类型*/
@property (nonatomic) UIKeyboardType keyboardType;
/**密文输入*/
@property (nonatomic) BOOL secureTextEntry;

///<input点击事件,设置这个参数将是input变成一个按钮，无法输入，只能做点击事件
@property (nonatomic,   copy) ClickActionBlock actionBlock;
///<点击模式下，展示的问题
@property (nonatomic,   copy) NSString  *actionText;
@end

NS_ASSUME_NONNULL_END
