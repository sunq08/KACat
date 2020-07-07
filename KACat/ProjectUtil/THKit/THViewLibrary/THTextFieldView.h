//
//  THTextFieldView.h
//  THKitProject
//
//  Created by 孙强 on 2020/5/29.
//  Copyright © 2020 sunq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** textField类型的枚举*/
typedef enum THTextFieldViewType {
    THTextFieldViewTypePlain          = 0,        //icon default
    THTextFieldViewTypeTitle          = 1,        //title
    THTextFieldViewTypeSubTitle       = 2,        //sub title
}THTextFieldViewType;
@interface THTextFieldView : UIView
/** @@初始化方法*/
+ (instancetype)textFieldViewType:(THTextFieldViewType)textFieldViewType;
- (instancetype)initWithFrame:(CGRect)frame type:(THTextFieldViewType)textFieldViewType;


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
