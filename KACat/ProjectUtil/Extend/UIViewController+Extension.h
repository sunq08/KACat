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
typedef void (^AlertIndexCallBackBlock)(NSInteger btnIndex);//回调block

@interface UIViewController (Extension)

///从xib中加载控制器
+ (instancetype)viewControllerFromNib;

///从 storyboard 加载ViewController
+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName Identifier:(NSString *)identifier;

///快速创建Alert 提示
- (void)showAlertMessage:(NSString *)message;

///简易Alert窗口，单一按钮，支持点击按钮回调
- (void)showAlertMessage:(NSString *)message completion:(AlertCallBackBlock)completion;

///简易Alert窗口，确认和取消按钮，支持点击确定按钮回调
- (void)showAlertWithCancel:(NSString *)message completion:(AlertCallBackBlock)completion;

/** 简易ActionSheet窗口*/
- (void)showActionSheetMessage:(NSString *)message items:(NSArray *)items completion:(AlertIndexCallBackBlock)completion;

@end
