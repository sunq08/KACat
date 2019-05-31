//
//  UIViewController+Extension.h
//  CollectionsOfExample
//
//  Created by mac on 16/7/17.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AlertTitle     @"提示"
#define AlertOK        @"好的"
#define AlertCancel    @"取消"

typedef void (^AlertCallBackBlock)(void);//回调block

@interface UIViewController (Extension)

/**
 从xib中加载控制器
 
 */
+ (instancetype)viewControllerFromNib;

/**
 从 storyboard 加载ViewController

 @param storyboardName storyboard  名字
 @param identifier 这个类的 storyboard ID（自己设置）

 */
+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName Identifier:(NSString *)identifier;

/**
 快速创建Alert 提示

 @param message 提示信息
 */
- (void)showAlertMessage:(NSString *)message;

/**
 简易Alert窗口，单一按钮，支持点击按钮回调
 
 @param message 提示信息
 @param completion 回调内容
 */
- (void)showAlertMessage:(NSString *)message completion:(AlertCallBackBlock)completion;

/**
 简易Alert窗口，确认和取消按钮，支持点击按钮回调(index:0确定，1取消)
 
 @param message 提示信息
 @param completion 回调内容
 */
- (void)showAlertWithCancel:(NSString *)message completion:(AlertCallBackBlock)completion;

@end
