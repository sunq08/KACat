//
//  IClassListViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "IClassListViewController.h"
#import "ClassDetailViewController.h"
#import "ClassAddViewController.h"
#import "ClassM.h"
@interface IClassListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *pageList;

@end

@implementation IClassListViewController{
    CGFloat _gradientProgress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)initUI{
    self.title = @"收入分类管理";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTable = tableView;
    [self.view addSubview:tableView];
    if (@available(iOS 11,*)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _headerView = [[UIImageView alloc] initWithImage:ImageNamed(@"m_banner")];
    _headerView.clipsToBounds = YES;
    _headerView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_headerView aboveSubview:tableView];
    
    self.hbd_barAlpha = 0.0;
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_add") style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    self.pageList = [NSMutableArray arrayWithCapacity:0];
}

- (void)loadData{
    [self.pageList removeAllObjects];
    
    DataBase *db = [DataBase sharedDataBase];
    
    NSString *where = [NSString stringWithFormat:@"where class_id like '200%%%%' and length(class_id) = 6"];
    [self.pageList addObjectsFromArray:[db getClassMListWhere:where]];
    
    [self.mainTable reloadData];
}

- (void)addClick{
    ClassAddViewController *addVC = [[ClassAddViewController alloc]init];
    addVC.p_class_id = self.class_id;
    [self.navigationController pushViewController:addVC animated:YES];
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
    
    ClassM *model = [self.pageList objectAtIndex:indexPath.row];
    cell.textLabel.text = model.class_name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",model.amount];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showAlertWithCancel:@"确定要删除该分类吗？" completion:^{
        ClassM *model = [self.pageList objectAtIndex:indexPath.row];
        [[DataBase sharedDataBase] deleteClassM:model];
        [self.pageList removeObject:model];
        [self.mainTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassM *model = [self.pageList objectAtIndex:indexPath.row];
    ClassDetailViewController *vc = [[ClassDetailViewController alloc]init];
    vc.class_id = model.class_id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UITableView *tableView = self.mainTable;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    CGRect headerFrame = headerView.frame;
    
    if (tableView.contentInset.top == 0) {
        UIEdgeInsets inset = UIEdgeInsetsZero;
        if (@available(iOS 11,*)) {
            inset.bottom = self.view.safeAreaInsets.bottom;
        }
        tableView.scrollIndicatorInsets = inset;
        inset.top = imageHeight;
        tableView.contentInset = inset;
        tableView.contentOffset = CGPointMake(0, -inset.top);
    }
    
    if (CGRectGetHeight(headerFrame) != imageHeight) {
        headerView.frame = [self headerImageFrame];
    }
}

- (CGRect) headerImageFrame {
    UITableView *tableView = self.mainTable;
    UIImageView *headerView = self.headerView;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    UIImage *headerImage = headerView.image;
    CGFloat imageHeight = headerImage.size.height / headerImage.size.width * width;
    
    CGFloat contentOffsetY = tableView.contentOffset.y + tableView.contentInset.top;
    if (contentOffsetY < 0) {
        imageHeight += -contentOffsetY;
    }
    
    CGRect headerFrame = self.view.bounds;
    if (contentOffsetY > 0) {
        headerFrame.origin.y -= contentOffsetY;
    }
    headerFrame.size.height = imageHeight;
    
    return headerFrame;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(self.headerView.frame);
    if (@available(iOS 11,*)) {
        headerHeight -= self.view.safeAreaInsets.top;
    } else {
        headerHeight -= [self.topLayoutGuide length];
    }
    
    CGFloat progress = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGFloat gradientProgress = MIN(1, MAX(0, progress  / headerHeight));
    gradientProgress = gradientProgress * gradientProgress * gradientProgress * gradientProgress;
    if (gradientProgress != _gradientProgress) {
        _gradientProgress = gradientProgress;
        
        self.hbd_barAlpha = _gradientProgress;
        [self hbd_setNeedsUpdateNavigationBar];
    }
    self.headerView.frame = [self headerImageFrame];
}
@end
