//
//  HUDManager.m
//  V60-OnlineMart
//
//  Created by SunQ on 2017/8/31.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import "HUDManager.h"
#import "UIImage+GIF.h"
// 文字大小
#define TEXT_SIZE    13.0f

#define Delay_Time  1.5f

@implementation HUDManager

+ (instancetype)sharedHUD {
    static id hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

- (instancetype)initWithView:(UIView *)view{
    self = [super initWithView:view];
    if (self) {
        self.bezelView.color = [UIColor blackColor];
        self.contentColor = [UIColor whiteColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.numberOfLines = 2;
        [self setRemoveFromSuperViewOnHide:YES];
        self.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
        [self setMinSize:CGSizeZero];
        self.userInteractionEnabled = NO;
    }
    return self;
}

+ (void)showStatus:(HUDManagerStatus)status text:(NSString *)text {
    HUDManager *HUD = [HUDManager sharedHUD];
    HUD.label.text = text;
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    if(status == HUDManagerStatusLoading){
        HUD.userInteractionEnabled = YES;
        HUD.mode = MBProgressHUDModeIndeterminate;
        [HUD showAnimated:YES];
    }else{
        HUD.bezelView.color = [UIColor blackColor];
        HUD.userInteractionEnabled = NO;
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"HUDManager" ofType:@"bundle"];
        UIImage *sucImage;
        if (status == HUDManagerStatusSuccess) {
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Success.png"];
            sucImage = [UIImage imageWithContentsOfFile:sucPath];
        }
        if (status == HUDManagerStatusError) {
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Error.png"];
            sucImage = [UIImage imageWithContentsOfFile:sucPath];
        }
        if (status == HUDManagerStatusWarning) {
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Warn.png"];
            sucImage = [UIImage imageWithContentsOfFile:sucPath];
        }
        if (status == HUDManagerStatusInfo) {
            NSString *sucPath = [bundlePath stringByAppendingPathComponent:@"MBHUD_Info.png"];
            sucImage = [UIImage imageWithContentsOfFile:sucPath];
        }
        
        HUD.mode = MBProgressHUDModeCustomView;
        UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
        HUD.customView = sucView;
        [HUD showAnimated:YES];
        [HUD setShowNow:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD setShowNow:NO];
            [HUD hideAnimated:YES];
        });
    }
}

+ (void)showMessage:(NSString *)text{
    HUDManager *HUD = [HUDManager sharedHUD];
    HUD.label.text = text;
    
    [HUD setMode:MBProgressHUDModeText];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD setShowNow:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Delay_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HUDManager sharedHUD] setShowNow:NO];
        [[HUDManager sharedHUD] hideAnimated:YES];
    });
}

+ (void)showWarning:(NSString *)text{
    [self showStatus:HUDManagerStatusWarning text:text];
}

+ (void)showError:(NSString *)text{
    [self showStatus:HUDManagerStatusError text:text];
}

+ (void)showSuccess:(NSString *)text{
    [self showStatus:HUDManagerStatusSuccess text:text];
}

+ (void)showLoading{
    [self showStatus:HUDManagerStatusLoading text:@""];
}

+ (void)showLoadingWith:(NSString *)text {
    [self showStatus:HUDManagerStatusLoading text:text];
}

+ (void)hideHUD {
    [[HUDManager sharedHUD] setShowNow:NO];
    [[HUDManager sharedHUD] hideAnimated:YES];
}


@end
