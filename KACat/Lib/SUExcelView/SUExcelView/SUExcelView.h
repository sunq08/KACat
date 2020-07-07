//
//  SUExcelView.h
//  GHKC
//
//  Created by SunQ on 2019/8/9.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//  网格视图封装，基于masry mjrefresh

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SUExcelView;
/** 数据源代理方法*/
@protocol SUExcelViewDelegate <NSObject>
#pragma mark - @required 必须设置的代理方法
@required
/** 共有几个列*/
- (NSInteger)numberOfColumnInExcelView:(SUExcelView *)excelView;
/** 共有几行*/
- (NSInteger)excelView:(SUExcelView *)excelView numberOfRowInSection:(NSInteger)section;
/** 动态设置cell内容*/
- (void)excelView:(SUExcelView *)excelView cellConfigWithLabel:(UILabel *)label column:(NSInteger)column indexPath:(NSIndexPath *)indexPath;

#pragma mark - @required 可选的代理方法
@optional
/** 标题内容宽度，默认60.0*/
- (CGFloat)excelView:(SUExcelView *)excelView titleLabelHeightWithColumn:(NSInteger)column;
/** 标题内容高度，默认44.0*/
- (CGFloat)excelView:(SUExcelView *)excelView titleLabelWidthWithIndexPath:(NSIndexPath *)indexPath;
/** 设置table标题数组，注意数组内容数量要与Column一致*/
- (NSArray<NSString *>*)excelTitlesWithexcelView:(SUExcelView *)excelView;
/** 点击cell的代理方法*/
- (void)excelView:(SUExcelView *)excelView didSelectCellWith:(NSIndexPath *)indexPath;
/** 点击cell的代理方法，暂未实现*/
- (void)excelView:(SUExcelView *)excelView didSelectCellWith:(NSIndexPath *)indexPath column:(NSInteger)column;
/** excel的上拉加载方法*/
- (void)excelViewPullUpRefresh:(SUExcelView *)excelView;
/** excel的下拉刷新方法*/
- (void)excelViewPullDownRefresh:(SUExcelView *)excelView;
@end
@interface SUExcelView : UIView
#pragma mark - @required 必须设置的属性/方法
/** 代理*/
@property (nonatomic, assign) id<SUExcelViewDelegate> delegate;
/** 初始化方法，alloc init后调用，可选参数在此时生效*/
- (void)initUI;
/** 刷新，设置完代理，获取到数据后调用*/
- (void)reloadData;

#pragma mark - @@optional 可选参数设置
/** 配置下拉刷新*/
@property (nonatomic, assign) BOOL     configPullDownRefresh;
/** 配置上拉加载*/
@property (nonatomic, assign) BOOL     configPullUpRefresh;
/** 头部视图*/
@property (nonatomic, strong) UIView    *excelHeadView;
/** 左侧锁定列效果，默认为NO，此代理方法支持单独表格配置*/
@property (nonatomic, assign) BOOL      lockLeft;
/** 关闭网格效果，默认为NO*/
@property (nonatomic, assign) BOOL      closeGrid;
/** 锁定网格数，此值只有在 lockLeft 为YES的情况下才会生效*/
@property (nonatomic, assign) NSInteger lockNumber;

/** 结束刷新状态*/
- (void)endRefreshStateWithNoMoreData:(BOOL)noMoreData;
@end

NS_ASSUME_NONNULL_END
