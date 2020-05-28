//
//  THTextField.h
//  GYSA
//
//  Created by SunQ on 2019/8/26.
//  Copyright © 2019年 itonghui. All rights reserved.
//  通用textfiled视图，左边可以是icon，也可以是title

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** textField类型的枚举*/
typedef enum THTextFieldType {
    THTextFieldTypePlain          = 0,        //icon default
    THTextFieldTypeTitle          = 1,        //title
}THTextFieldType;

@interface THTextField : UIView

/** @@初始化方法*/
+ (instancetype)textFieldViewType:(THTextFieldType)textFieldType;
- (instancetype)initWithFrame:(CGRect)frame type:(THTextFieldType)textFieldType;


/** @@icon interface*/
/** icon 尺寸*/
@property (nonatomic, assign) CGSize iconSize;
/** icon 图片*/
@property (nonatomic, strong) UIImage *iconImage;


/** @@title interface*/
/** 标题宽度*/
@property (nonatomic, assign) CGFloat titleWidth;
/** 标题内容*/
@property (nonatomic,   copy) NSString *title;
/** 标题对齐方式，默认左对齐*/
@property (nonatomic) NSTextAlignment titleAlign;


/** @@textField interface*/
/** 占位符*/
@property (nonatomic, strong) NSString *placeholder;
/** 文字内容*/
@property (nullable, nonatomic, copy) NSString *text;
/** 字体大小，默认15*/
@property (nonatomic) UIFont *font;
/** 需要限制的字数*/
@property (nonatomic,  copy) NSNumber *limitLength;
/**输入框的风格 默认为UITextBorderStyleNone*/
@property (nonatomic) UITextBorderStyle textBorderStyle;
/**键盘类型*/
@property (nonatomic) UIKeyboardType keyboardType;
/**密文输入*/
@property (nonatomic) BOOL secureTextEntry;
/**控制不可输入*/
@property (nonatomic) BOOL disable;
@end

NS_ASSUME_NONNULL_END
