//
//  AppUserInfo.m
//  V60-OnlineMart
//
//  Created by 任芳 on 2017/2/8.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import "AppUserInfo.h"
#import "BaseNavigationController.h"
//#import "LoginVC.h"

#define UserDefault_UserName    @"UserDefault_UserName"
#define UserDefault_TK          @"UserDefault_TK"

#define KEY_SearchHistory       @"KEY_SearchHistory"

@interface AppUserInfo()

@end

@implementation AppUserInfo

singleton_implementation(AppUserInfo);   //创建一个单例

#pragma mark - 存储用户名
+ (void)setCacheUserName:(NSString *)userName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:UserDefault_UserName];
    [userDefaults synchronize];
}
+ (NSString*)getCacheUserName {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDefaults objectForKey:UserDefault_UserName];
    return userName;
}
#pragma mark - 存储tk
+(void)setCacheTK:(NSString *)tk{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:tk forKey:UserDefault_TK];
    [userDefaults synchronize];
}
+(NSString*)getCacheTK{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tk = [userDefaults objectForKey:UserDefault_TK];
    return tk;
}
+(void)removeCacheTK{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UserDefault_TK];
}

#pragma mark - 弹出登录页面
+ (void)presentLoginVC{
    [AppUserInfo sharedAppUserInfo].isLogin = NO;
    
//    LoginVC *loginVC = [[LoginVC alloc]init];
//    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
//    [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC{
    UIViewController* result = nil;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController* appRootVC = window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView* frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UIWindow class]])
    {
        UITabBarController* tabbar =  (UITabBarController *)appRootVC;
        UINavigationController* nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
    }
    else if ([nextResponder isKindOfClass:[UITabBarController class]]){
        
        UITabBarController* tabbar = (UITabBarController *)nextResponder;
        UINavigationController* nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
    } else {
        
        result = nextResponder;
    }
    return result;
}

#pragma mark - 存检索历史数据
+ (void)setCatchSearchHistory:(NSMutableArray *)SearchHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:SearchHistory forKey:KEY_SearchHistory];
}
//取检索历史数据
+ (NSMutableArray*)getCatchSearchHistory {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *searchHistory = [userDefaults objectForKey:KEY_SearchHistory];
    return searchHistory;
}

@end
