//
//  CenterViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/13.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "CenterViewController.h"
#import "EClassListViewController.h"
#import "IClassListViewController.h"
#import "UIViewController+SlideFromSide.h"
#import "HYCalendarView.h"
#import "AccountM.h"
#import "ClassM.h"
#import "BillM.h"
@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTable;
@property (weak, nonatomic) IBOutlet UIImageView *head_img;
@property (weak, nonatomic) IBOutlet UILabel *name_lab;
@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.head_img layoutBorderRadius:15 color:MWhiteColor width:2];
}
- (IBAction)setClick {

}
- (IBAction)clearClick:(id)sender {
    [[DataBase sharedDataBase] deleteDataBase];
}
- (IBAction)syncClick:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
        cell.textLabel.font = SYSTEMFONT(15);
        cell.textLabel.textColor = [UIColor hex:@"333333"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"支出分类管理";
    } else if (indexPath.row == 1){
        cell.textLabel.text = @"收入分类管理";
    } else if (indexPath.row == 2){
        cell.textLabel.text = @"模拟支出数据";
    } else if (indexPath.row == 3){
        cell.textLabel.text = @"模拟收入数据";
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        EClassListViewController *classVC = [[EClassListViewController alloc]init];
        classVC.class_id = 100;
        UIViewController *current = [Helper getCurrentVC];
        [current.navigationController pushViewController:classVC animated:YES];
        [self hide];
    }else if (indexPath.row == 1){
        IClassListViewController *classVC = [[IClassListViewController alloc]init];
        classVC.class_id = 200;
        UIViewController *current = [Helper getCurrentVC];
        [current.navigationController pushViewController:classVC animated:YES];
        [self hide];
    }else if (indexPath.row == 2){
        HYCalendarView *view = [[HYCalendarView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
        view.getTime = ^(NSString * firstDay, NSString * lastDay){
            [self addSimulationData:firstDay Type:0];
        };
        [view show];
    }else if (indexPath.row == 3){
        HYCalendarView *view = [[HYCalendarView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
        view.getTime = ^(NSString * firstDay, NSString * lastDay){
            [self addSimulationData:firstDay Type:1];
        };
        [view show];
    }
}

- (void)addSimulationData:(NSString *)date Type:(NSInteger)type{
    BillM *model = [[BillM alloc]init];
    model.type = type;
    model.time = [NSDate timeToDate:date withDateFormat:DateFormatD];
    model.amount = (float)[Helper getRandomNumber:0 to:200];
    
    DataBase *db = [DataBase sharedDataBase];
    if(type == 0){//支出
        NSString *fe_where = [NSString stringWithFormat:@"where class_id like '100%%%%' and length(class_id) = 6"];
        NSArray *fe_class = [db getClassMListWhere:fe_where];
        if(fe_class.count==0){
            [HUDManager showWarning:@"请先维护分类"];
            return;
        }
        int er = arc4random() % [fe_class count];
        ClassM *feM = [fe_class objectAtIndex:er];
        
        NSString *se_where = [NSString stringWithFormat:@"where class_id like '%ld%%%%' and length(class_id) = 9",feM.class_id];
        NSArray *se_class = [db getClassMListWhere:se_where];
        if(se_class.count != 0){
            int sr = arc4random() % [se_class count];
            ClassM *seM = [se_class objectAtIndex:sr];
            
            model.class_id = seM.class_id;
            model.class_name = seM.class_name;
        }else{
            model.class_id = feM.class_id;
            model.class_name = feM.class_name;
        }
    }else{//收入
        NSString *i_where = [NSString stringWithFormat:@"where class_id like '200%%%%' and length(class_id) = 6"];
        NSArray *i_class = [db getClassMListWhere:i_where];
        if(i_class.count==0){
            [HUDManager showWarning:@"请先维护分类"];
            return;
        }
        int ir = arc4random() % [i_class count];
        ClassM *iM = [i_class objectAtIndex:ir];
        
        model.class_id = iM.class_id;
        model.class_name = iM.class_name;
    }
    
    NSArray *accounts = [db getAllAccountM];
    if(accounts.count==0){
        [HUDManager showWarning:@"请先维护账户"];
        return;
    }
    int ar = arc4random() % [accounts count];
    AccountM *accountM = [accounts objectAtIndex:ar];
    model.account_id = accountM.pkid;
    model.account = accountM.name;
    
    [[DataBase sharedDataBase] addBillM:model];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_HomeReload object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
