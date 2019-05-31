//
//  UIViewController+Extension.m
//  CollectionsOfExample
//
//  Created by mac on 16/7/17.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "UIViewController+Extension.h"
@implementation UIViewController (Extension)

+ (instancetype)viewControllerFromNib {
    UIViewController *viewController = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return viewController;
}

+ (instancetype)viewControllerFromStoryboardName:(NSString *)storyboardName Identifier:(NSString *)identifier{
    
    return [[UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    
}

/**
 快速创建Alert 提示
 
 @param message 提示信息
 */
- (void)showAlertMessage:(NSString *)message{
    [self showAlertMessage:message completion:nil];
}

/**
 简易Alert窗口，单一按钮，支持点击按钮回调
 
 @param message 提示信息
 @param completion 回调内容
 */
- (void)showAlertMessage:(NSString *)message completion:(AlertCallBackBlock)completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    UIAlertAction *singleAction = nil;
    singleAction = [UIAlertAction actionWithTitle:AlertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(completion) completion();
    }];
    [alertController addAction:singleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 简易Alert窗口，确认和取消按钮，支持点击按钮回调(index:0确定，1取消)
 
 @param message 提示信息
 @param completion 回调内容
 */
- (void)showAlertWithCancel:(NSString *)message completion:(AlertCallBackBlock)completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:AlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    //添加按钮
    UIAlertAction *singleAction = nil;
    singleAction = [UIAlertAction actionWithTitle:AlertOK style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(completion) completion();
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:AlertCancel style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:singleAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
