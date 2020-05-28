//
//  THDataPresentView.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataPresentView.h"
#import "THDataImagesCell.h"
#import "THDataImageCell.h"
#import "THDataTextCell.h"
#import "THKitConfig.h"
@interface THDataPresentView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTable;
@end
@implementation THDataPresentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.mainTable];
    
    [self.mainTable mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
}

- (void)setPresentHeadView:(UIView *)presentHeadView{
    _presentHeadView = presentHeadView;
    
    self.mainTable.tableHeaderView = presentHeadView;
}

- (void)reloadData{
    [self.mainTable reloadData];
}

- (void)reloadIndexPathDataWithIndexPath:(NSIndexPath *)indexPath{
    [self.mainTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - super get
- (UITableView *)mainTable{
    if(!_mainTable){
        _mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.estimatedRowHeight = 44.0;
        [_mainTable registerClass:[THDataTextCell class] forCellReuseIdentifier:@"THDataTextCell"];
        [_mainTable registerClass:[THDataImageCell class] forCellReuseIdentifier:@"THDataImageCell"];
        [_mainTable registerClass:[THDataImagesCell class] forCellReuseIdentifier:@"THDataImagesCell"];
    }
    return _mainTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(presentView:numberOfRowInSection:)]){
        return [self.delegate presentView:self numberOfRowInSection:section];
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.delegate respondsToSelector:@selector(numberOfSectionInPresentView:)]){
        return [self.delegate numberOfSectionInPresentView:self];
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(presentView:heightForHeaderInSection:)]){
        return [self.delegate presentView:self heightForHeaderInSection:section];
    }
    if([self.delegate respondsToSelector:@selector(presentView:configSectionHeaderForSection:view:)]){
        return 44.0;
    }
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.delegate respondsToSelector:@selector(presentView:configCellWithIndexPath:)]){
        return nil;
    }
    THDataM *model = [self.delegate presentView:self configCellWithIndexPath:indexPath];
    if(model.cellType == 0){
        THDataTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THDataTextCell"];
        [cell configCellModel:model];
        return cell;
    }else if(model.cellType == 1){
        THDataImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THDataImageCell"];
        [cell configCellModel:model];
        return cell;
    }else if(model.cellType == 2){
        THDataTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THDataTextCell"];
        [cell configCellModel:model];
        return cell;
    }else if(model.cellType == 3){
        THDataImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"THDataImagesCell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell configCellModel:model];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(presentView:configSectionHeaderForSection:view:)]){
        THDataSectionHead *view = [[THDataSectionHead alloc]init];
        [self.delegate presentView:self configSectionHeaderForSection:section view:view];
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(presentView:didSelectRowAtIndexPath:)]){
        [self.delegate presentView:self didSelectRowAtIndexPath:indexPath];
    }
}

@end
