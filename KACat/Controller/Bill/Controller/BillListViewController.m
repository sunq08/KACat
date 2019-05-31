//
//  BillListViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/27.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "BillListViewController.h"
#import "BillAddViewController.h"

#import "UIViewController+SlideFromSide.h"
#import "UIScrollView+EmptyDataSet.h"

#import "BillListTableViewCell.h"
#import "HYCalendarView.h"

#import "BillM.h"
@interface BillListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) BillS *billS;
@property (nonatomic,strong) NSMutableArray *pageList;

@property (nonatomic, weak) UITableView *mainTable;

@end

@implementation BillListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    NSString *today = [NSDate currentTimeWithFormat:@"yyyy-MM-dd"];
    self.billS = [[BillS alloc] init];
    self.billS.start_time = today;
    self.billS.end_time = today;
    
    [self loadData];
}

#pragma mark - initUI
- (void)initUI{
    self.title = @"账单列表";
    
    self.view.backgroundColor = rgb(255, 130, 0);
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:mainTable];
    
    mainTable.tableFooterView = [UIView new];
    mainTable.backgroundColor = MWhiteColor;
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.emptyDataSetSource = self;
    mainTable.emptyDataSetDelegate = self;
    self.mainTable = mainTable;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_add") style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    UIBarButtonItem *calendarBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"home_calendar") style:UIBarButtonItemStylePlain target:self action:@selector(calendarClick)];
    self.navigationItem.rightBarButtonItems = @[addBtn,calendarBtn];
    
    //下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mainTable.mj_header = header;
    
    self.pageList = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark - loadData
- (void)loadData{
    [self.pageList removeAllObjects];
    
    NSArray *bills = [[DataBase sharedDataBase] getBillListWithBillS:self.billS];
    [self.pageList addObjectsFromArray:bills];
    
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
- (void)calendarClick{
    HYCalendarView *view = [[HYCalendarView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
    view.itemType = HYCalendarItemTypeSquartCollected;
    view.chooseType = HYCalendarChooseDouble;
    WeakSelf;
    view.getTime = ^(NSString * firstDay, NSString * lastDay){
        if(ValidStr(firstDay)){
            weakSelf.billS.start_time = firstDay;
            weakSelf.billS.end_time = firstDay;
        }
        if(ValidStr(lastDay)){
            weakSelf.billS.end_time = lastDay;
        }
        [weakSelf loadData];
    };
    [view show];
}

- (void)addClick{
    BillAddViewController *billVC = [[BillAddViewController alloc]init];
    WeakSelf;
    billVC.refreshBlock = ^{
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:billVC animated:YES];
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

- (void)quickAddBillClick{
    
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

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSDictionary *dict = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]};
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"今天还没有记账呦，快来记一笔吧！" attributes:dict];
    
    return string;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -MScreenHeight/2 + TopHeight + 100;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    BillAddViewController *billVC = [[BillAddViewController alloc]init];
    [self.navigationController pushViewController:billVC animated:YES];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return ImageNamed(@"home_nodata");
}

//- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
//    scrollView.contentOffset = CGPointZero;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
