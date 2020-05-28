//
//  THKitConfig.h
//  GYSA
//
//  Created by SunQ on 2019/9/4.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#define THScreenWidth       [UIScreen mainScreen].bounds.size.width
#define THScreenHeight      [UIScreen mainScreen].bounds.size.height
#define THStatusBarHeight   [[UIApplication sharedApplication] statusBarFrame].size.height
#define THNavBarHeight      44.0
//本项目已全局配置y的起始坐标为导航栏底部，计算坐标时请留意
#define THTopHeight         (THStatusBarHeight + THNavBarHeight)

//通用背景（头部、导航条）基础设置
static const BOOL           THCommonBGUseImage      = YES;         //通用背景（导航/按钮）是否使用图片
static NSString * const     THCommonBGImageName     = @"nav_bar";  //通用背景图片名称
#define THCommonBGColor     thrgb(30.0,185.0,238.0)                //通用背景的颜色

@interface THKitConfig : NSObject
/**设置圆角*/
+ (void)layoutViewRadioWith:(UIView *)view radio:(int)radio;
/**设置圆角边框*/
+ (void)layoutViewRadioWith:(UIView *)view radio:(int)radio color:(UIColor *)color;

+ (void)layoutViewBottomLineWith:(UIView *)view margin:(CGFloat)margin;
/**设置高度*/
+ (void)layoutViewHeightWith:(UIView *)view height:(float)height;
/**设置宽度*/
+ (void)layoutViewWidthWith:(UIView *)view left:(float)left;
/** 根据颜色获取图片*/
+ (UIImage *)imageWithColor:(UIColor *)color;
/** 获取上级controller*/
+ (UIViewController *)getSuperViewController:(UIView *)view;
/** 计算文字宽度 */
+ (CGFloat)widthWithString:(NSString *)string fs:(CGFloat)fs height:(CGFloat)height;
@end
/** 通过RGB创建颜色 rgb(173.0,23.0,11.0)*/
UIColor *thrgb(CGFloat red, CGFloat green, CGFloat blue);
NS_ASSUME_NONNULL_END
