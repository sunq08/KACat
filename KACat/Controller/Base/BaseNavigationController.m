//
//  BaseNavigationController.m
//  SunQDemo
//
//  Created by SunQ on 2017/10/24.
//  Copyright © 2017年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

//APP生命周期中 只会执行一次
+ (void)initialize{
    //导航栏主题 title文字属性
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBarTintColor:rgb(255, 130, 0)];
    [navBar setTintColor:MWhiteColor];
    [navBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [navBar setBackgroundImage:ImageNamed(@"nav_bar") forBarMetrics:UIBarMetricsDefault];
//    [navBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [super pushViewController:viewController animated:animated];
    // 修改ios 11 tabBra的frame bug
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}

@end
