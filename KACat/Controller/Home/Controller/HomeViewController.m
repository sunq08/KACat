//
//  HomeViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/6.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "HomeViewController.h"
#import "CenterViewController.h"
#import "BillAddViewController.h"

#import "UIViewController+SlideFromSide.h"

#import "BillListTableViewCell.h"
#import "HomeHeadView.h"

#import "BillM.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) CenterViewController *centerVC;
@property (nonatomic,strong) HomeHeadView *headView;

@property (nonatomic,strong) BillS *billS;
@property (nonatomic,strong) NSMutableArray *pageList;

@property (nonatomic, weak) UITableView *mainTable;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    NSString *today = [NSDate currentTimeWithFormat:@"yyyy-MM-dd"];
    self.billS = [[BillS alloc] init];
    self.billS.start_time = today;
    self.billS.end_time = today;
    
    [self loadData];
    
    //注册监听事件，登录成功后的事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:Notification_HomeReload object:nil];
}

#pragma mark - initUI
- (void)initUI{
    self.hbd_barHidden = YES;
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, -TopHeight, MScreenWidth, MScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:mainTable];
    
    self.headView = [HomeHeadView viewFromXib];
    self.headView.frame = CGRectMake(0, 0, MScreenWidth, 300);
    mainTable.tableHeaderView = self.headView;
    mainTable.tableFooterView = [UIView new];
    mainTable.backgroundColor = MWhiteColor;
    
    WeakSelf;
    self.headView.centerBlock = ^{
        [weakSelf.centerVC show];
    };
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    self.mainTable = mainTable;
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTable.mj_header = header;
    
    self.centerVC = [[CenterViewController alloc]initWithNibName:@"CenterViewController" bundle:nil];
    self.centerVC.view.frame = CGRectMake(0, 0, 300, MScreenHeight);
    [self.centerVC initSlideFoundationWithDirection:SlideDirectionFromLeft];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanEvent:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    self.pageList = [NSMutableArray arrayWithCapacity:0];
}

- (void)edgePanEvent:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.edges == UIRectEdgeLeft && sender.state == UIGestureRecognizerStateBegan) {
        [self.centerVC show];
    }
}

#pragma mark - loadData
- (void)loadData{
    [self.pageList removeAllObjects];

    NSArray *bills = [[DataBase sharedDataBase] getBillListWithBillS:self.billS];
    [self.pageList addObjectsFromArray:bills];
    
    NSString *start = [NSDate getMonthStartWithDateFormat:DateFormatD];
    NSString *today = [NSDate currentTimeWithFormat:DateFormatD];
    CGFloat expenditure = [[DataBase sharedDataBase] getAmountWithStart:start end:today type:0];
    self.headView.expenditureLabel.text = [NSString stringWithFormat:@"%.2f",expenditure];
    CGFloat income = [[DataBase sharedDataBase] getAmountWithStart:start end:today type:1];
    self.headView.incomeLabel.text = (income == 0)?@"暂无收入":[NSString stringWithFormat:@"%.2f",income];
    
    [self.mainTable reloadData];
}

- (void)pullRefresh{
    WeakSelf;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.mainTable.mj_header endRefreshing];
        [weakSelf loadData];
    });
}

#pragma mark - privateFunction
- (void)centerClick{
    [self.centerVC show];
}

- (void)updateBillWith:(BillM *)model{
    BillAddViewController *billVC = [[BillAddViewController alloc]init];
    billVC.billM = model;
    WeakSelf;
    billVC.refreshBlock = ^{
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:billVC animated:YES];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.pageList) return self.pageList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *custIntifer = @"BillListTableViewCell";
    BillListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:custIntifer];
    if (!cell) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"BillListTableViewCell" owner:nil options:nil];
        cell = [nibs firstObject];
        
        [cell.icon layoutRadius:22];
    }
    
    BillM *model = [self.pageList objectAtIndex:indexPath.row];
    cell.class_name.text = model.class_name;
    NSString *type = (model.type == 0)?@"支出":@"收入";
    cell.type_name.text = [NSString stringWithFormat:@"%@",type];
    cell.price.text = [NSString stringWithFormat:@"￥%.2f",model.amount];
    cell.add_time.text = [NSDate dateToString:model.time withDateFormat:DateFormatD];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        BillM *model = [self.pageList objectAtIndex:indexPath.row];
        [[DataBase sharedDataBase] deleteBillM:model];
        [self.pageList removeObject:model];
        [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        BillM *model = [self.pageList objectAtIndex:indexPath.row];
        [self updateBillWith:model];
    }];
    return @[deleteAction,editAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

