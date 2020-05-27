//
//  UIButton+Category.h
//  DIMI
//
//  Created by SunQ on 2018/5/18.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片与标题显示样式
typedef NS_ENUM(NSInteger, THButtonStyle) {
    THButtonStyleImageLeft      = 0,/// 图片在左，文字在右（默认，水平居中）
    THButtonStyleImageRight     = 1,/// 图片居右，文字居左（水平居中）
    SYButtonStyleImageTop       = 2,/// 图片居上，文字居下（垂直居中）
    SYButtonStyleImageBottom    = 3,/// 图片居下，文字居上（垂直居中）
};

@interface UIButton (Category)
/** 设置colorg为背景图*/
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
/** 按钮标题-normal*/
@property (nonatomic, strong) NSString *titleNormal;
/** 按钮标题-selected*/
@property (nonatomic, strong) NSString *titleSelected;
/** 按钮图片-normal*/
@property (nonatomic, strong) UIImage *imageNormal;
/** 按钮图片-selected*/
@property (nonatomic, strong) UIImage *imageSelected;
/** 按钮标题颜色-normal*/
@property (nonatomic, strong) UIColor *titleColorNormal;
/** 按钮标题颜色-selected*/
@property (nonatomic, strong) UIColor *titleColorSelected;
/** 字体大小*/
@property (nonatomic, strong) UIFont *titleFont;

/// 图片与标题显示样式（offset大于0时拉开距离，offset小于0时缩小距离）
- (void)buttonStyle:(THButtonStyle)style offSet:(CGFloat)offset;

/** 倒计时按钮(使用场景：获取验证码倒计时)*/
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle;
@end
