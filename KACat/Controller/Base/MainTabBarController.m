//
//  MainTabBarController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/7.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "WaterViewController.h"
#import "AccountViewController.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self drawTabBarView];
}

//选项卡背景色
#define TabBgColor [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1]
//选项卡标题颜色（通常）
#define TabTextNromalColor [UIColor colorWithRed:76/255. green:76/255. blue:76/255. alpha:1]
//选项卡标题颜色（选中）
#define TabTextSelectColor  [UIColor colorWithRed:194/255. green:0/255. blue:45/255. alpha:1]

- (void)drawTabBarView{
    BaseNavigationController *firstNav = [[BaseNavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    BaseNavigationController *secondNav = [[BaseNavigationController alloc] initWithRootViewController:[WaterViewController new]];
    BaseNavigationController *thirdNav = [[BaseNavigationController alloc] initWithRootViewController:[AccountViewController new]];
    self.viewControllers = @[firstNav,secondNav,thirdNav];
    
    NSArray *titles = @[@"总览",@"流水",@"账户"];
    NSArray *normalImages = @[@"icon_home",@"icon_water",@"icon_account"];
    NSArray *highlightImages = @[@"icon_homeH",@"icon_waterH",@"icon_accountH"];
    [self.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = titles[idx];
        obj.image = [[UIImage imageNamed:normalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        obj.selectedImage = [[UIImage imageNamed:highlightImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    
    //设置字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TabTextNromalColor, NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: TabTextSelectColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
