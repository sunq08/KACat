//
//  WaterViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/6.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "WaterViewController.h"
@interface WaterViewController ()

@end

@implementation WaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI{
    self.title = @"流水";
    self.view.backgroundColor = MTableBgColor;
}

- (void)loadData{
    
}
@end
