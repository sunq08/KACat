//
//  ClassDetailViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "ClassDetailViewController.h"
#import "ClassAddViewController.h"
#import "ClassM.h"
@interface ClassDetailViewController ()
@property (nonatomic,strong) ClassM     *classM;    //修改的class
@end

@implementation ClassDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MWhiteColor;
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_set") style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = editBtn;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self loadData];
}

- (void)loadData{
    NSString *sql = [NSString stringWithFormat:@"where class_id = %ld",self.class_id];
    ClassM *model = [[DataBase sharedDataBase] getClassMListWhere:sql][0];
    self.classM = model;
    
    self.title = self.classM.class_name;
}

- (void)editClick{
    ClassAddViewController *addVC = [[ClassAddViewController alloc]init];
    addVC.classM = self.classM;
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
