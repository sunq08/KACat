//
//  SUExcelCell.m
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "SUExcelCell.h"
#import "SUExcelConfig.h"
@interface SUExcelCell()<UIScrollViewDelegate>
//基础属性
@property (nonatomic, strong) UIScrollView      *mainScroll;
//逻辑数据
@property (nonatomic, assign) BOOL              isAllowedNotification;
@property (nonatomic, assign) CGFloat           lastOffX;
//业务数据
@property (nonatomic, assign) NSInteger         column;     //有多少列
@property (nonatomic, strong) NSMutableArray    *cellWs;    //label宽度
@property (nonatomic,   copy) NSString          *notif;     //通知id
@property (nonatomic, assign) BOOL              lockLeft;   //
@property (nonatomic, assign) BOOL              closeGrid;  //
@property (nonatomic, assign) NSInteger lockNumber;         //锁定竖排数
@end
@implementation SUExcelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellInfo:(NSMutableDictionary *)cellInfo{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.column = [[cellInfo objectForKey:EXCellInfoColumn] integerValue];
        self.cellWs = [cellInfo objectForKey:EXCellInfoWidths];
        self.notif = [cellInfo objectForKey:EXCellInfoNotif];
        self.lockLeft = [[cellInfo objectForKey:EXCellInfoLock] boolValue];
        self.closeGrid = [[cellInfo objectForKey:EXCellCloseGrid] boolValue];
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
        [self initUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:self.notif object:nil];
    }
    return self;
}

- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.mainScroll];
    
    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
    
//    self.lastOffX = 100.f;
//    [self.mainScroll mas_makeConstraints:^(MASConstraintMaker *make) {
//       
//        make.left.mas_equalTo(self.contentView.left).offset(100.f);
//        make.top.left.right.mas_equalTo(self.contentView);
//    }];
    
    float labelL = 0;
    SUExcelLabel *lastLabel = nil;
    for (int i = 0; i < self.column; i++) {
        SUExcelLabel *titleLabel = [[SUExcelLabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = EXBaseFont;
        titleLabel.tag = (i+1);
        titleLabel.textColor = [UIColor darkGrayColor];
        if(i < _lockNumber && self.lockLeft){
            [self.contentView addSubview:titleLabel];
            titleLabel.backgroundColor = EXBackgroundColor;
        }else{
            [self.mainScroll addSubview:titleLabel];
        }
        
        float labelW = (i<=self.cellWs.count)?[[self.cellWs objectAtIndex:i] floatValue]:60.0;
        
        if(i == 0){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.mainScroll);
                make.left.equalTo(self.mainScroll);
                make.width.equalTo(@(labelW));
                make.height.equalTo(self.mainScroll.mas_height);
            }];
        }else if(i == self.column - 1){
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.mainScroll);
                make.left.equalTo(lastLabel.mas_right);
                make.right.equalTo(self.mainScroll);
                make.width.equalTo(@(labelW));
                make.height.equalTo(self.mainScroll.mas_height);
            }];
        }else{
            if(self.lockLeft && i == _lockNumber){
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.mainScroll);
                    make.left.equalTo(self.mainScroll).offset(labelL);
                    make.width.equalTo(@(labelW));
                    make.height.equalTo(self.mainScroll.mas_height);
                }];
            }else{
                [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.mainScroll);
                    make.left.equalTo(lastLabel.mas_right);
                    make.width.equalTo(@(labelW));
                    make.height.equalTo(self.mainScroll.mas_height);
                }];
            }
        }
        lastLabel = titleLabel;
        
        if(i != (self.column-1) && !self.closeGrid){//添加边线
            CALayer *layer = [CALayer layer];
            layer.frame = CGRectMake(labelW, 0, 1, EXCellHeight);
            layer.backgroundColor = [UIColor groupTableViewBackgroundColor].CGColor;
            [titleLabel.layer addSublayer:layer];
        }
        
        labelL += labelW;
    }
    
    self.mainScroll.contentSize = CGSizeMake(labelL, 40.f);
    
    UILabel *lineLeft = [[UILabel alloc]init];
    lineLeft.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineLeft];
    
    UILabel *lineRight = [[UILabel alloc]init];
    lineRight.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineRight];
    
    UILabel *lineBottom = [[UILabel alloc]init];
    lineBottom.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:lineBottom];
    
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
    
    //使用scroll铺在cell上不知道为啥会使didselectcell方法无效，因此手动增加点击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.mainScroll addGestureRecognizer:singleTap];
}

- (void)singleTap:(UITapGestureRecognizer *)sender{
    if(self.excelCellClick){
        self.excelCellClick(self.indexPath);
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    self.mainScroll.backgroundColor = (self.indexPath.row%2==0)?[UIColor whiteColor]:EXSimpleColor;
    if(self.lockLeft){
        UILabel *label = (UILabel *)[self.contentView viewWithTag:1];
        label.backgroundColor = (self.indexPath.row%2==0)?[UIColor whiteColor]:EXSimpleColor;
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
    }
    return _mainScroll;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isAllowedNotification = NO;//
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isAllowedNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.isAllowedNotification) {//是自身才发通知去tableView以及其他的cell
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notif object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    self.isAllowedNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:self.notif object:nil];
}

//多种手势处理
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (UILabel *)configLabelWithColumn:(NSInteger)column{
    UILabel *label = (UILabel *)[self.contentView viewWithTag:(column+1)];
    return label;
}
@end
