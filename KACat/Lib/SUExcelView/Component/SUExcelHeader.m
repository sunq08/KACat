//
//  SUExcelHeader.m
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "SUExcelHeader.h"
#import "SUExcelConfig.h"
@interface SUExcelHeader()<UIScrollViewDelegate>
//基础属性
@property (nonatomic, strong) UIScrollView      *mainScroll;
//逻辑数据
@property (nonatomic, assign) BOOL              isAllowedNotification;
@property (nonatomic, assign) CGFloat           lastOffX;
@property (nonatomic,   copy) NSString          *notif;
//业务数据
@property (nonatomic, assign) NSInteger         column;
@property (nonatomic, strong) NSMutableArray    *cellWs;
@property (nonatomic, strong) NSMutableArray    *titles;
@property (nonatomic, assign) BOOL              lockLeft;    //
@property (nonatomic, assign) BOOL              closeGrid;   //
@property (nonatomic, assign) NSInteger lockNumber;          //锁定竖排数
@end
@implementation SUExcelHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier notificationID:(NSString *)notificationID{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        self.notif = notificationID;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:self.notif object:nil];
    }
    return self;
}

- (void)setCellInfo:(NSMutableDictionary *)cellInfo{
    _cellInfo = cellInfo;
    
    self.column = [[cellInfo objectForKey:EXCellInfoColumn] integerValue];
    self.cellWs = [cellInfo objectForKey:EXCellInfoWidths];
    self.titles = [cellInfo objectForKey:EXCellInfoTitles];
    self.lockLeft = [[cellInfo objectForKey:EXCellInfoLock] boolValue];
    self.closeGrid = [[cellInfo objectForKey:EXCellCloseGrid] boolValue];
    self.lockNumber = [[cellInfo objectForKey:EXCellInfoLockNumber] integerValue];
    //此处判断是否锁定第一竖排
    if (self.lockLeft) {
        //锁定竖排的情况下，判断锁定竖排是否为0，为0则赋值1锁定第一排不为0则锁定指定排数
        //（因为这个类不一定是通过SUExcelView入口进来的）
        self.lockNumber = [[cellInfo objectForKey:EXCellInfoLockNumber] integerValue];
        if (!self.lockNumber) {
            self.lockNumber = 1;
        }
    } else {
        //值为0则不锁定竖排
        self.lockNumber = 0;
    }
    
    [self reloadData];
}


- (void)initUI{
    self.contentView.backgroundColor = EXBaseColor;
    [self.contentView addSubview:self.mainScroll];
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(EXCellHeight);
//        [make edges];
    }];
    
    UILabel *lineLeft = [[UILabel alloc]init];
    lineLeft.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineLeft];
    
    UILabel *lineRight = [[UILabel alloc]init];
    lineRight.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineRight];
    
    UILabel *lineBottom = [[UILabel alloc]init];
    lineBottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineBottom];
    
    UILabel *lineTop = [[UILabel alloc]init];
    lineTop.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineTop];
    
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1.0));
    }];
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@(1.0));
    }];
    [lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.contentView);
        make.height.equalTo(@(1.0));
    }];
    [lineTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.equalTo(self.contentView);
        make.height.equalTo(@(1.0));
    }];
}

- (void)reloadData{
    for (UIView *view in [self.mainScroll subviews]) {
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    float labelL = 0;
    UILabel *lastLabel = nil;
    for (int i = 0; i < self.column; i++) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = EXBaseFont;
        titleLabel.tag = (i+1);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor darkTextColor];
        titleLabel.text = [self.titles objectAtIndex:i];
        if(i < self.lockNumber && self.lockLeft){
            [self.contentView addSubview:titleLabel];
            titleLabel.backgroundColor = EXBackgroundColor;
        }else{
            [self.mainScroll addSubview:titleLabel];
        }
        
        float labelW = (i<=self.cellWs.count)?[[self.cellWs objectAtIndex:i] floatValue]:60.0;
        if(i == 0){
            if(self.lockLeft){
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mainScroll).offset(1);
                    make.bottom.equalTo(self.mainScroll).offset(-1);
                    make.left.equalTo(self.mainScroll).offset(1);
                    make.width.equalTo(@(labelW-1));
                }];
            }else{
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.mainScroll);
                    make.left.equalTo(self.mainScroll);
                    make.width.equalTo(@(labelW));
                    make.height.equalTo(self.mainScroll.mas_height);
                }];
            }
            
        }else if(i == self.column - 1){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.mainScroll);
                make.left.equalTo(lastLabel.mas_right);
                make.right.equalTo(self.mainScroll);
                make.width.equalTo(@(labelW));
                make.height.equalTo(self.mainScroll.mas_height);
            }];
        }else{
            if(self.lockLeft && i == self.lockNumber){
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.mainScroll);
                    make.left.equalTo(self.mainScroll).offset(labelL);
                    make.width.equalTo(@(labelW));
                    make.height.equalTo(self.mainScroll.mas_height);
                }];
            }else{
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.mainScroll).offset(1);
                    make.bottom.equalTo(self.mainScroll).offset(-1);
                    make.left.equalTo(lastLabel.mas_right);
                    make.width.equalTo(@(labelW));
                }];
            }
        }
        lastLabel = titleLabel;
        
        if(i != (self.column-1) && !self.closeGrid){//添加边线
            CALayer *layer = [CALayer layer];
            float lineX = (i == 0 && self.lockLeft)?labelW-1:labelW;
            layer.frame = CGRectMake(lineX, 0, 1, EXCellHeight);
            layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [titleLabel.layer addSublayer:layer];
        }
        labelL += labelW;
    }
}

#pragma mark - super get
- (UIScrollView *)mainScroll{
    if(!_mainScroll){
        _mainScroll = [[UIScrollView alloc]init];
        _mainScroll.backgroundColor = EXBackgroundColor;
        _mainScroll.bounces = NO;
        _mainScroll.showsHorizontalScrollIndicator = NO;
        _mainScroll.delegate = self;
        _mainScroll.backgroundColor = EXBaseColor;
    }
    return _mainScroll;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isAllowedNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isAllowedNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isAllowedNotification) {//是自身才发通知去tableView以及其他的cell
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notif object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x),@"tableViewHeadView":@1}];
    }
    self.isAllowedNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj != self) {
        self.isAllowedNotification = YES;
        if (self.lastOffX != x) {
            [self.mainScroll setContentOffset:CGPointMake(x, 0) animated:NO];
        }
        self.lastOffX = x;
    }else{
        self.isAllowedNotification = NO;
    }
    obj = nil;
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_notif object:nil];
}

@end
