//
//  AccountViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/6.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountAddTypeViewController.h"
#import "AccountM.h"
@interface AccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *pageList;
@property (nonatomic,assign) UITableView *mainTable;

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)initUI{
    self.title = @"账户";
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:mainTable];
    
    mainTable.tableFooterView = [UIView new];
    mainTable.backgroundColor = MTableBgColor;
    
    mainTable.delegate = self;
    mainTable.dataSource = self;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_add") style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    self.pageList = [NSMutableArray arrayWithCapacity:0];
    
    self.mainTable = mainTable;
}

- (void)loadData{
    [self.pageList removeAllObjects];
    
    DataBase *db = [DataBase sharedDataBase];
    [self.pageList addObjectsFromArray:[db getAllAccountM]];

    [self.mainTable reloadData];
}

- (void)addClick{
    AccountAddTypeViewController *vc = [[AccountAddTypeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.pageList) return self.pageList.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        
        cell.textLabel.font = SYSTEMFONT(15);
        cell.textLabel.textColor = [UIColor hex:@"333333"];
        
        cell.detailTextLabel.font = SYSTEMFONT(12);
        cell.detailTextLabel.textColor = [UIColor hex:@"999999"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    AccountM *model = [self.pageList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",model.amount];
    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self showAlertWithCancel:@"确定要删除该账户吗？" completion:^{
            AccountM *model = self.pageList[indexPath.row];
            [[DataBase sharedDataBase] deleteAccountM:model];
            [self.pageList removeObject:model];
            [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }];
    }];
    
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountM *model = self.pageList[indexPath.row];
    AccountAddTypeViewController *vc = [[AccountAddTypeViewController alloc]init];
    vc.accountM = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
