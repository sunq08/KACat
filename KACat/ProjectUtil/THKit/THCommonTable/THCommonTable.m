//
//  THCommonTable.m
//  QIAQIA
//
//  Created by 孙强 on 2020/4/3.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "THCommonTable.h"
#import "ThCommonCell.h"
@interface THCommonTable()<UITableViewDelegate,UITableViewDataSource,THCommonCellDelegate>
@property (nonatomic, strong) UITableView *mainTable;
@property (nonatomic, strong) THCommonConfigM *configM;
@property (nonatomic, assign) BOOL configDone;
@end
@implementation THCommonTable
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTable.backgroundColor  = [UIColor groupTableViewBackgroundColor];
    self.mainTable.delegate         = self;
    self.mainTable.dataSource       = self;
    self.mainTable.separatorStyle   = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.mainTable];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
}

- (void)reloadData{
    if(!self.configDone){
        if([self.delegate respondsToSelector:@selector(commonTable:configCellStyleWithModel:)]){
            [self.delegate commonTable:self configCellStyleWithModel:self.configM];
        }
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
    }

    self.configDone = YES;
    [self.mainTable reloadData];
}

- (void)reloadDataWithIndex:(NSInteger)index{
    [self.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - mj refresh
- (void)pullUpRefresh{
    if([self.delegate respondsToSelector:@selector(commonTablePullUpRefresh:)]){
        [self.delegate commonTablePullUpRefresh:self];
    }
}

- (void)pullDownRefresh{
    if([self.delegate respondsToSelector:@selector(commonTablePullDownRefresh:)]){
        [self.mainTable.mj_footer resetNoMoreData];
        [self.delegate commonTablePullDownRefresh:self];
    }
}


#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.delegate numberOfRowInCommonTable:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ThCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThCommonCell"];
    if(!cell){
        cell = [[ThCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ThCommonCell" configM:self.configM];
    }
    THDataConfigM *model = [self.delegate commonTable:self configCellDataWithIndex:indexPath.row];
    cell.index      = indexPath.row;
    cell.delegate   = self;
    cell.dataM      = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height    = 8.0 + 36.0;
    if(self.configM.openDouble){
        height      += ceilf(self.configM.contentNumber/2.0f)*27;
    }else height    += self.configM.contentNumber*27;
    
    NSArray *array  = self.configM.buttonList;
    if(array.count  != 0){
        height      += 40.0;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(commonTable:didSelectCellAtIndex:)]){
        [self.delegate commonTable:self didSelectCellAtIndex:indexPath.row];
    }
}

- (void)commonCellButtonClickWithIdentifier:(NSString *)identifier index:(NSInteger)index{
    if([self.delegate respondsToSelector:@selector(commonTable:buttonClickWithIdentifier:index:)]){
        [self.delegate commonTable:self buttonClickWithIdentifier:identifier index:index];
    }
}


#pragma mark - super set
- (void)setTableHeaderView:(UIView *)tableHeaderView{
    _tableHeaderView = tableHeaderView;
    
    self.mainTable.tableHeaderView = tableHeaderView;
}

- (void)setTableFooterView:(UIView *)tableFooterView{
    _tableFooterView = tableFooterView;
    
    self.mainTable.tableFooterView = tableFooterView;
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
- (THCommonConfigM *)configM{
    if(!_configM){//设置默认值
        _configM = [[THCommonConfigM alloc]init];
        _configM.contentNumber = 0;
        _configM.openDouble = NO;
        _configM.buttonList = @[];
    }
    return _configM;
}
@end
