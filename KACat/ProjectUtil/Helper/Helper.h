//
//  Helper.h
//  SunQDemo
//
//  Created by SunQ on 2017/6/2.
//  Copyright © 2017年 SunQ. All rights reserved.
//  常用方法封装
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class WKWebViewConfiguration;
@interface Helper : NSObject

+ (Helper *)shareInstance;

#pragma mark - 拨打电话 打开网页
/**  拨打电话*/
+ (void)makePhoneCallWithTelNumber:(NSString *)tel;
/**  直接打开网页*/
+ (void)openURLWithUrlString:(NSString *)url;
/**  当前界面截图*/
+ (UIImage *)imageFromCurrentView:(UIView *)view;
/** 获取当前屏幕显示的viewcontroller*/
+ (UIViewController *)getCurrentVC;
/**  字典转化成字符串*/
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;
/**  生成随机数 n到m*/
+(int)getRandomNumber:(int)from to:(int)to;
#pragma mark - 获取用户手机信息
/**  获取手机品牌型号*/
+ (NSString *)getUserPhoneModelNumber;
/**  获取手机系统版本*/
+ (NSString *)getPhoneVersion;
/**  获取app版本号*/
+ (NSString *)getAPPVersion;
/**  手机序列号（设备号）*/
+ (NSString *)getIdentifierNumber;
/**  获取设备IP地址 （只在手机真机上可用）*/
+ (NSString *)getIPAddress;
// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName;


#pragma mark -   倒计时按钮 返回页面重置时间
/**
 *  倒计时按钮(使用场景：获取验证码倒计时)
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title 结束时的
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param button   要操作的按钮
 */
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle disposeButton:(UIButton *)button;

#pragma mark - 获取自适应的webview config
+ (WKWebViewConfiguration *)getWKWebViewConfig;

#pragma mark - 背景后退动画效果
+ (void)backGroundAnimationShowWith:(UIView *)view;

+ (void)backGroundAnimationHideWith:(UIView *)view;

@end
