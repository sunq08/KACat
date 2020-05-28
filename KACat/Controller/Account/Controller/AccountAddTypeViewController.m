//
//  AccountAddTypeViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/10.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "AccountAddTypeViewController.h"
 
#import "FSTextView.h"
#import "AccountM.h"
#import <FMDB/FMDB.h>
@interface AccountAddTypeViewController ()<THFormViewDelegate>
@property (nonatomic, strong) THFormView *formView;//
@property (nonatomic, strong) NSMutableArray *cells;//
@end

@implementation AccountAddTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI{
    NSString *title = (self.accountM)?@"修改账户信息":@"新增账户类型";
    self.title = title;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.formView = [[THFormView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.formView];
    self.formView.delegate = self;
    
    [self.formView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
    
    self.cells = [NSMutableArray arrayWithCapacity:0];
    
    THFormTextM *nameM = [THFormTextM cellModelWithIdentifier:@"name"];
    nameM.title = @"账户名";
    nameM.limitLength = @10;
    nameM.mustIn = YES;
    [self.cells addObject:nameM];
    
    THFormImageM *iconM = [THFormImageM cellModelWithIdentifier:@"icon"];
    iconM.title = @"图标";
    iconM.maxCount = 1;
    [self.cells addObject:iconM];

    THFormTextM *amountM = [THFormTextM cellModelWithIdentifier:@"amount"];
    amountM.title = @"余额";
    amountM.limitLength = @10;
    amountM.keyboardType = UIKeyboardTypeDecimalPad;
    [self.cells addObject:amountM];
    
    THFormTextM *remarkM = [THFormTextM cellModelWithIdentifier:@"remark"];
    remarkM.title = @"备注";
    remarkM.isTextArea = YES;
    remarkM.limitLength = @100;
    [self.cells addObject:remarkM];
    
    [self.formView reloadData];
}

- (void)loadData{
    if(!self.accountM) return;
    THFormTextM *nameM = [self.cells objectAtIndex:0];
    nameM.value = self.accountM.name;
    
    THFormTextM *amountM = [self.cells objectAtIndex:2];
    amountM.value = format(@"%.2f",self.accountM.amount);
    
    THFormTextM *remarkM = [self.cells objectAtIndex:3];
    remarkM.value = self.accountM.remark;
    
    if(self.accountM.icon){
//        THFormImageM *iconM = [self.cells objectAtIndex:1];
//        UIImage *icon = [UIImage imageWithData:self.accountM.icon];
    }
    [self.formView reloadData];
}

///<共有多少行
- (NSInteger)numberOfIndexInFormView:(THFormView *)formView{
    return self.cells.count;
}
///<配置cell信息
- (THFormBaseM *)formView:(THFormView *)formView cellModelForIndex:(NSInteger)index{
    THFormBaseM *model = [self.cells objectAtIndex:index];
    return model;
}

///<点击确定调用的方法，将数据带出
- (void)formView:(THFormView *)formView didSubmitClick:(NSMutableDictionary *)dict{
    AccountM *model = [[AccountM alloc] init];
    model.name = [dict objectForKey:@"name"];
    model.amount = [[dict objectForKey:@"amount"] doubleValue];
    model.remark = [dict objectForKey:@"remark"];
    
    if(self.accountM){
        model.pkid = self.accountM.pkid;
        [[DataBase sharedDataBase] updateAccountM:model];
    }else{
        [[DataBase sharedDataBase] addAccountM:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
