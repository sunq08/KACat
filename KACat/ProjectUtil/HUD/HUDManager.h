//
//  HUDManager.h
//  V60-OnlineMart
//
//  Created by SunQ on 2017/8/31.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, HUDManagerStatus) {
    /** 成功 */
    HUDManagerStatusSuccess,
    /** 失败 */
    HUDManagerStatusError,
    /** 警告*/
    HUDManagerStatusWarning,
    /** 提示 */
    HUDManagerStatusInfo,
    /** 等待 */
    HUDManagerStatusLoading
};

@interface HUDManager : MBProgressHUD

/** 返回一个 HUD 的单例 */
+ (instancetype)sharedHUD;

/**   是否正在显示*/
@property (nonatomic, assign, getter = isShowNow) BOOL showNow;

/** 在 window 上添加一个 HUD */
+ (void)showStatus:(HUDManagerStatus)status text:(NSString *)text;



#pragma mark - 建议使用的方法

/** 在 window 上添加一个只显示文字的 HUD 不禁用页面元素 */
+ (void)showMessage:(NSString *)text;
+ (void)showWarning:(NSString *)text;
+ (void)showError:(NSString *)text;
+ (void)showSuccess:(NSString *)text;

/** 在 window 上添加一个提示`等待`的 HUD, 需要手动关闭 */
+ (void)showLoading;

+ (void)showLoadingWith:(NSString *)text;

/** 手动隐藏 HUD */
+ (void)hideHUD;


@end
