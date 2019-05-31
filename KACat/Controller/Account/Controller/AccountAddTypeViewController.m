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
@interface AccountAddTypeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet FSTextView *remarkTV;

@end

@implementation AccountAddTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    if(self.accountM) [self loadData];
}

- (void)initUI{
    NSString *title = (self.accountM)?@"修改账户信息":@"新增账户类型";
    self.title = title;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_save") style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [self.nameTF setValue:@10 forKey:@"LimitInput"];
    [self.amountTF setValue:@15 forKey:@"LimitInput"];
}

- (void)loadData{
    AccountM *model = self.accountM;
    
    self.nameTF.text = model.name;
    self.amountTF.text = [NSString stringWithFormat:@"%.2f",model.amount];
    self.remarkTV.text = model.remark;
    
    if(model.icon){
        UIImage *icon = [UIImage imageWithData:model.icon];
        self.icon.image = icon;
    }
}

- (void)saveClick{
    if(!ValidStr(self.nameTF.text)){
        [HUDManager showWarning:@"账户名称不能为空！"];
        return;
    }

    if(ValidStr(self.amountTF.text) && ![self.amountTF.text isValidPrice]){
        [HUDManager showWarning:@"请输入正确的金额！"];
        return;
    }
    AccountM *model = [[AccountM alloc] init];
    model.name = self.nameTF.text;
    model.amount = [self.amountTF.text doubleValue];
    if(ValidStr(self.remarkTV.text)){
        model.remark = self.remarkTV.text;
    }
    
    if(self.accountM){
        model.pkid = self.accountM.pkid;
        [[DataBase sharedDataBase] updateAccountM:model];
    }else{
        [[DataBase sharedDataBase] addAccountM:model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectImageClick:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
