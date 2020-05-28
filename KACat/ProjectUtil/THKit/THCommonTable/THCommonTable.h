//
//  THCommonTable.h
//  QIAQIA
//
//  Created by 孙强 on 2020/4/3.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THCommonConfigM.h"
NS_ASSUME_NONNULL_BEGIN
@class THCommonTable;
/** 数据源代理方法*/
@protocol THCommonTableDelegate <NSObject>
@required
/*共有几个cell*/
- (NSInteger)numberOfRowInCommonTable:(THCommonTable *)commonTable;
/*配置每个cell的内容*/
- (THDataConfigM *)commonTable:(THCommonTable *)commonTable configCellDataWithIndex:(NSInteger)index;
@optional
/* 配置cell样式*/
- (void)commonTable:(THCommonTable *)table configCellStyleWithModel:(THCommonConfigM *)configM;
/* cell button的点击事件*/
- (void)commonTable:(THCommonTable *)table buttonClickWithIdentifier:(NSString *)identifier index:(NSInteger)index;
/* cell select 事件*/
- (void)commonTable:(THCommonTable *)table didSelectCellAtIndex:(NSInteger)index;
/** 上拉加载方法*/
- (void)commonTablePullUpRefresh:(THCommonTable *)commonTable;
/** 下拉刷新方法*/
- (void)commonTablePullDownRefresh:(THCommonTable *)commonTable;
@end
@interface THCommonTable : UIView
/** 代理*/
@property (nonatomic, assign) id<THCommonTableDelegate> delegate;
/* 设置完代理调用一次，并且配置项只会生效一次 */
- (void)reloadData;

- (void)reloadDataWithIndex:(NSInteger)index;
#pragma mark - @@optional 可选参数设置
/** 配置下拉刷新*/
@property (nonatomic, assign) BOOL configPullDownRefresh;
/** 配置上拉加载*/
@property (nonatomic, assign) BOOL configPullUpRefresh;
/** 结束刷新状态*/
- (void)endRefreshStateWithNoMoreData:(BOOL)noMoreData;
/** 头部视图*/
@property (nonatomic, strong) UIView *tableHeaderView;
/** 尾部视图*/
@property (nonatomic, strong) UIView *tableFooterView;
@end

NS_ASSUME_NONNULL_END
