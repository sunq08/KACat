//
//  THScreenView.m
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

//screen view
static const CGFloat    THDropViewHeight   = 350.0;//顶部筛选框的高度
static const CGFloat    THSideViewWidth    = 300.0;//侧边筛选框的宽度
//static const CGFloat    THCellDefaltHeight = 80.0; //cell默认高度
//static const CGFloat    THLabelMinWidth    = 48.0; //label最小宽度

#define THScreenResetBgColor        thrgb(206.0,238.0,248.0)//重置按钮背景颜色，默认淡蓝
#define THScreenResetTextColor      thrgb(0.0,186.0,242.0)//重置按钮字体颜色，默认深蓝
#define THScreenSureBgColor         thrgb(0.0,186.0,242.0)//确定按钮背景颜色，默认深蓝
#define THScreenSureTextColor       [UIColor whiteColor]//确定按钮字体颜色，默认白色


#import "THScreenView.h"
#import "THKitConfig.h"

#import "THScreenBaseCell.h"
#import "THScreenCardM.h"
@interface THScreenView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,assign) THScreenViewStyle style;      //0,下拉菜单。1，侧滑菜单
@property (nonatomic, strong) UIView        *mainView;      //内容视图
@property (nonatomic, strong) UIView        *maskView;      //蒙版
@property (nonatomic, strong) UIView        *navView;       //头部
@property (nonatomic, strong) UILabel       *titleLab;      //头部标题
@property (nonatomic, strong) UITableView  *mainTable;      //内容table
@property (nonatomic, strong) UIButton      *resetBtn;      //重置按钮
@property (nonatomic, strong) UIButton      *sureBtn;       //确定按钮
@property (nonatomic, assign) NSInteger     cellNum;
@property (nonatomic, strong) NSMutableArray *models;       //存储数据源
@end
@implementation THScreenView
- (id)initWithFrame:(CGRect)frame style:(THScreenViewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.maskView];
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.mainTable];
    [self.mainView addSubview:self.resetBtn];
    [self.mainView addSubview:self.sureBtn];
    
    if(self.style == THScreenViewStyleDrop){//下拉
        self.maskView.frame = CGRectMake(0, 0, THScreenWidth, THScreenHeight);
        self.mainView.frame = CGRectMake(0, 0, THScreenWidth, THDropViewHeight);
        self.mainTable.frame = CGRectMake(0, 0, THScreenWidth, THDropViewHeight-70);
        float buttonW = (THScreenWidth - 45)/2;
        self.resetBtn.frame = CGRectMake(15, THDropViewHeight - 15 - 40, buttonW, 40);
        self.sureBtn.frame = CGRectMake(30+buttonW, THDropViewHeight - 15 - 40, buttonW, 40);
    }else{//侧滑
        [self.mainView addSubview:self.navView];
        [self.navView addSubview:self.titleLab];
        
        self.maskView.frame = CGRectMake(0, 0, THScreenWidth, THScreenHeight);
        self.mainView.frame = CGRectMake(THScreenWidth-THSideViewWidth, 0, THSideViewWidth, THScreenHeight);
        self.navView.frame = CGRectMake(0, 0, THSideViewWidth, THTopHeight);
        self.titleLab.frame = CGRectMake(0, THStatusBarHeight, THSideViewWidth, THNavBarHeight);
        self.mainTable.frame = CGRectMake(0, THTopHeight, THSideViewWidth, THScreenHeight-THTopHeight-70);
        float buttonW = (THSideViewWidth - 45)/2;
        self.resetBtn.frame = CGRectMake(15, THScreenHeight - 15 - 40, buttonW, 40);
        self.sureBtn.frame = CGRectMake(30+buttonW, THScreenHeight - 15 - 40, buttonW, 40);
    }
}

- (void)reloadData{
    if(!self.models){
        self.models = [NSMutableArray arrayWithCapacity:0];
    }
    [self.models removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(numberOfCellWithScreenView:)]) {
        self.cellNum = [self.delegate numberOfCellWithScreenView:self];
    }
    
    for (int index = 0; index < self.cellNum; index ++) {
        THScreenBaseM *model = [self.delegate screenView:self cellModelForIndex:index];
        [self.models addObject:model];
    }
    [self.mainTable reloadData];
}

- (void)reloadCellWith:(NSInteger)index{
    if(index >= self.cellNum){
        NSLog(@"数组越界了！检查一下是不是哪里写错了");
        return;
    }
    [self.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - event
- (void)addPanEventWithVC:(UIViewController *)viewController{
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanEvent:)];
    edgePan.edges = (self.style == THScreenViewStyleDrop)?UIRectEdgeTop:UIRectEdgeRight;
    [viewController.view addGestureRecognizer:edgePan];
}

- (void)edgePanEvent:(UIScreenEdgePanGestureRecognizer *)sender {
    if(self.style == THScreenViewStyleDrop){
        if (sender.edges == UIRectEdgeTop && sender.state == UIGestureRecognizerStateBegan) {
            [self show];
        }
    }else{
        if (sender.edges == UIRectEdgeRight && sender.state == UIGestureRecognizerStateBegan) {
            [self show];
        }
    }
}

- (void)show{
    if(self.style == THScreenViewStyleDrop){//下拉
        self.maskView.frame = CGRectMake(0, THTopHeight, THScreenWidth, THScreenHeight);
        self.mainView.frame = CGRectMake(0, THTopHeight, THScreenWidth, THDropViewHeight);
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if(self.style == THScreenViewStyleDrop){//下拉
        self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [THKitConfig layoutViewHeightWith:self.mainView height:0];
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [THKitConfig layoutViewHeightWith:self.mainView height:THDropViewHeight];
        } completion:nil];
    } else {
        self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [THKitConfig layoutViewWidthWith:self.mainView left:THScreenWidth];
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [THKitConfig layoutViewWidthWith:self.mainView left:THScreenWidth-THSideViewWidth];
        } completion:nil];
    }
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    if(self.style == THScreenViewStyleDrop){//下拉
        self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [THKitConfig layoutViewHeightWith:self.mainView height:0];
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [THKitConfig layoutViewHeightWith:self.mainView height:THDropViewHeight];
        } completion:nil];
    } else {
        self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [THKitConfig layoutViewWidthWith:self.mainView left:THScreenWidth];
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [THKitConfig layoutViewWidthWith:self.mainView left:THScreenWidth-THSideViewWidth];
        } completion:nil];
    }
}

- (void)close{
    if(self.style == THScreenViewStyleDrop){//下拉
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [THKitConfig layoutViewHeightWith:self.mainView height:0];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:.2 animations:^{
            self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            [THKitConfig layoutViewWidthWith:self.mainView left:THScreenWidth];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (CGRectContainsPoint([self frame], pt) && !CGRectContainsPoint([self.mainView frame], pt)) {
        [self close];
    }
}

#pragma mark - super get
- (UIView *)maskView{
    if(!_maskView){
        _maskView = [[UIView alloc]init];
        
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    }
    return _maskView;
}

- (UIView *)mainView{
    if(!_mainView){
        _mainView = [[UIView alloc]init];
        
        _mainView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainView.layer.masksToBounds   = YES;
    }
    return _mainView;
}

- (UIView *)navView{
    if(!_navView){
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = THCommonBGColor;
    }
    return _navView;
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.text = @"筛选";
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UITableView *)mainTable{
    if(!_mainTable){
        _mainTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _mainTable.translatesAutoresizingMaskIntoConstraints = NO;
        _mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _mainTable.delegate = self;
        _mainTable.dataSource = self;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.showsVerticalScrollIndicator = NO;
    }
    return _mainTable;
}

- (UIButton *)resetBtn{
    if(!_resetBtn){
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_resetBtn setTitleColor:THScreenResetTextColor forState:UIControlStateNormal];
        _resetBtn.backgroundColor = THScreenResetBgColor;
        [_resetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sureBtn setTitleColor:THScreenSureTextColor forState:UIControlStateNormal];
        _sureBtn.backgroundColor = THScreenSureBgColor;
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

#pragma mark - table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (self.models)?self.models.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.models && self.models.count != 0) {
        THScreenBaseM *model = [self.models objectAtIndex:indexPath.row];
        Class class = NSClassFromString(model.cellClass);
        THScreenBaseCell *cell = [class cellWithIdentifier:model.identifier tableView:tableView];
        [cell setupDataModel:model];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.models && self.models.count != 0) {
        THScreenBaseM *model = [self.models objectAtIndex:indexPath.row];
        if([model.cellClass isEqualToString:@"THScreenCardCell"]){
            THScreenCardM *cellM = (THScreenCardM *)model;
            float width = (self.style == THScreenViewStyleDrop)?(THScreenWidth-30):(THSideViewWidth-30);
            return [cellM getCardViewHeightWithSupW:width];
        }
    }
    return 80.0;
}

#pragma mark - click
- (void)resetClick{
    [self endEditing:YES];
    for (int index = 0; index < self.cellNum; index ++) {
        THScreenBaseM *model = [self.models objectAtIndex:index];
        [model resetValue];
        [self.mainTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (int index = 0; index < self.cellNum; index ++) {
        THScreenBaseM *model = [self.models objectAtIndex:index];
        [dict addEntriesFromDictionary:model.data];
    }
    if([self.delegate respondsToSelector:@selector(screenView:searchEventWithDict:)]){
        [self.delegate screenView:self searchEventWithDict:dict];
    }
    if([self.delegate respondsToSelector:@selector(screenView:searchEventWithDict:reset:)]){
        [self.delegate screenView:self searchEventWithDict:dict reset:YES];
    }
    [self close];
}

- (void)sureClick{
    [self endEditing:YES];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (int index = 0; index < self.cellNum; index ++) {
        THScreenBaseM *model = [self.models objectAtIndex:index];
        [dict addEntriesFromDictionary:model.data];
    }
    if([self.delegate respondsToSelector:@selector(screenView:searchEventWithDict:)]){
        [self.delegate screenView:self searchEventWithDict:dict];
    }
    if([self.delegate respondsToSelector:@selector(screenView:searchEventWithDict:reset:)]){
        [self.delegate screenView:self searchEventWithDict:dict reset:NO];
    }
    [self close];
}
/** 触发确认筛选事件*/
- (void)simulationSubmitBttonClick{
    [self sureClick];
}

@end
