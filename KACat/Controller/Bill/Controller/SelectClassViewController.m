//
//  SelectClassViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/16.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "SelectClassViewController.h"
#import "ClassM.h"
@interface SelectClassViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *pageList;
@end

@implementation SelectClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    NSInteger classId = (self.type == 0)?100:200;
    NSString *className = (self.type == 0)?@"支出":@"收入";
    [self loadData:classId ClassName:className];
}

- (void)initUI{
    self.title = @"选择分类";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable = tableView;
    [self.view addSubview:tableView];
    
    self.pageList = [NSMutableArray arrayWithCapacity:0];
}

- (void)loadData:(NSInteger)classId ClassName:(NSString *)className{
    NSInteger length = (classId == 100 || classId == 200)?6:9;
    NSString *where = [NSString stringWithFormat:@"where class_id like '%ld%%%%' and length(class_id) = %ld",classId,length];
    DataBase *db = [DataBase sharedDataBase];
    NSArray *sub = [db getClassMListWhere:where];
    
    if (sub.count == 0) {
        WeakSelf;
        if(weakSelf.refreshBlock){
            weakSelf.refreshBlock(classId,className);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    [self.pageList removeAllObjects];
    [self.pageList addObjectsFromArray:sub];
    [self.mainTable reloadData];
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
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ClassM *model = [self.pageList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.class_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassM *model = self.pageList[indexPath.row];
    if(model.class_id < 1000000){//有下级
        [self loadData:model.class_id ClassName:model.class_name];
    }else{
        WeakSelf;
        if(weakSelf.refreshBlock){
            weakSelf.refreshBlock(model.class_id,model.class_name);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc{
    MLog(@"销毁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
