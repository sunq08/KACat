//
//  HomeHeadView.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/27.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "HomeHeadView.h"
#import "BillAddViewController.h"
#import "BillListViewController.h"
@interface HomeHeadView()
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headT;

@end

@implementation HomeHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.buttonView layoutRadius:18];
    self.headT.constant = StatusBarHeight+7;
}

- (IBAction)personCenterClick:(id)sender {
    if(self.centerBlock){
        self.centerBlock();
    }
}

- (IBAction)addBillClick:(id)sender {
    UIViewController *vc = [Helper getCurrentVC];
    BillAddViewController *addVC = [[BillAddViewController alloc]init];
    [vc.navigationController pushViewController:addVC animated:YES];
}

- (IBAction)quickAddBillClick:(id)sender {
    
}

- (IBAction)billListClick:(id)sender {
    UIViewController *vc = [Helper getCurrentVC];
    BillListViewController *billListVC = [[BillListViewController alloc]init];
    [vc.navigationController pushViewController:billListVC animated:YES];
}

@end
