//
//  SUExcelView.m
//  GHKC
//
//  Created by SunQ on 2019/8/9.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "SUExcelView.h"
#import "SUExcelConfig.h"
#import "SUExcelCell.h"
#import "SUExcelHeader.h"
#pragma mark - excel
@interface SUExcelView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) NSMutableArray *cellWs;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger lockColumnNumber;
@property (nonatomic, assign) NSInteger row;
//通知-name
@property (nonatomic,   copy) NSString *notificationID;
@end
@implementation SUExcelView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initUI];
        self.notificationID = [NSString stringWithFormat:@"%p",self];
        //默认锁定竖排数 1
        self.lockNumber = 1;
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.mainTable];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
    
    self.cellWs = [NSMutableArray arrayWithCapacity:0];
    
    //上拉加载
    if(self.configPullUpRefresh){
        self.mainTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(pullUpRefresh)];
    }
    
    //下拉刷新
    if(self.configPullDownRefresh){
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownRefresh)];
        header.lastUpdatedTimeLabel.hidden = YES;
        self.mainTable.mj_header = header;
    }
    
    if(self.excelHeadView){
        self.mainTable.tableHeaderView = self.excelHeadView;
    }
    
    self.lockColumnNumber = YES;
}

- (void)reloadData{
    self.column = [self.delegate numberOfColumnInExcelView:self];
    self.row = [self.delegate excelView:self numberOfRowInSection:0];
    
    [self.cellWs removeAllObjects];
    for (int i = 0; i < self.column; i ++) {
        CGFloat cellW = 60.0;
        if([self.delegate respondsToSelector:@selector(excelView:titleLabelHeightWithColumn:)]){
            cellW = [self.delegate excelView:self titleLabelHeightWithColumn:i];
        }
        if(!cellW || cellW == 0.0) cellW = 60.0;
        [self.cellWs addObject:@(cellW)];
    }
    
    [self.mainTable reloadData];
}

- (void)pullUpRefresh{
    if([self.delegate respondsToSelector:@selector(excelViewPullUpRefresh:)]){
        [self.delegate excelViewPullUpRefresh:self];
    }
}

- (void)pullDownRefresh{
    if([self.delegate respondsToSelector:@selector(excelViewPullDownRefresh:)]){
        [self.delegate excelViewPullDownRefresh:self];
    }
}

- (void)endRefreshStateWithNoMoreData:(BOOL)noMoreData{
    if(self.configPullUpRefresh){
        if(noMoreData){
            [self.mainTable.mj_footer endRefreshingWithNoMoreData];
        }else [self.mainTable.mj_footer endRefreshing];
    }
    if(self.configPullDownRefresh){
        [self.mainTable.mj_header endRefreshing];
    }
}
#pragma mark - super get
- (UITableView *)mainTable{
    if(!_mainTable){
        _mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.tableFooterView = [UIView new];
        _mainTable.backgroundColor = EXBackgroundColor;
        _mainTable.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _mainTable.showsVerticalScrollIndicator = NO;
    }
    return _mainTable;
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SUExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:EXCellIdentifier];
    if(!cell){
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:@(self.column) forKey:EXCellInfoColumn];
        [dict setObject:self.cellWs forKey:EXCellInfoWidths];
        [dict setObject:self.notificationID forKey:EXCellInfoNotif];
        [dict setObject:@(self.lockLeft) forKey:EXCellInfoLock];
        [dict setObject:@(self.closeGrid) forKey:EXCellCloseGrid];
        [dict setObject:@(self.lockNumber) forKey:EXCellInfoLockNumber];
        cell = [[SUExcelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EXCellIdentifier cellInfo:dict];
    }
    cell.indexPath = indexPath;
    if([self.delegate respondsToSelector:@selector(excelView:didSelectCellWith:)]){
        __weak typeof(self) weakSelf = self;
        cell.excelCellClick = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf.delegate excelView:weakSelf didSelectCellWith:indexPath];
        };
    }
    
    for (int i = 0; i < self.column; i ++) {
        UILabel *label = [cell configLabelWithColumn:i];
        [self.delegate excelView:self cellConfigWithLabel:label column:i indexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(excelView:titleLabelWidthWithIndexPath:)]){
        return [self.delegate excelView:self titleLabelWidthWithIndexPath:indexPath];
    }
    return EXCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(excelTitlesWithexcelView:)]){
        return EXCellHeight;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(excelTitlesWithexcelView:)]){
        SUExcelHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:EXHeaderIdentifier];
        if(!view){
            view = [[SUExcelHeader alloc]initWithReuseIdentifier:EXHeaderIdentifier notificationID:self.notificationID];
        }
        //未设置self.delegate时就会调用本方法，与cellForRow不同，因此，业务数据不能在初始化时就设置
        NSArray *titles = [self.delegate excelTitlesWithexcelView:self];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        [dict setObject:@(self.column) forKey:EXCellInfoColumn];
        [dict setObject:self.cellWs forKey:EXCellInfoWidths];
        [dict setObject:titles forKey:EXCellInfoTitles];
        [dict setObject:@(self.lockLeft) forKey:EXCellInfoLock];
        [dict setObject:@(self.closeGrid) forKey:EXCellCloseGrid];
        [dict setObject:@(self.lockNumber) forKey:EXCellInfoLockNumber];
        view.cellInfo = dict;
        return view;
    }
    return [UIView new];
}

@end
