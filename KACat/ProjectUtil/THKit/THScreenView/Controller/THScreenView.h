//
//  THScreenView.h
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THScreenTextM.h"
#import "THScreenSelectM.h"
#import "THScreenMultiSelectM.h"
#import "THScreenDateM.h"
#import "THScreenCardM.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum THScreenViewStyle {
    THScreenViewStyleDrop       = 0,        //下拉菜单
    THScreenViewStyleSide       = 1,        //侧滑菜单-右侧
}THScreenViewStyle;

@class THScreenView;
/** 数据源代理方法*/
@protocol THScreenViewDelegate <NSObject>
@required
/** 共有几个选项*/
- (NSInteger)numberOfCellWithScreenView:(THScreenView *)screenView;
/** 设置单个选项的类型，标题等信息*/
- (THScreenBaseM *)screenView:(THScreenView *)screenView cellModelForIndex:(NSInteger)index;
@optional
/** 点击重置、确定调用的方法，将数据带出*/
- (void)screenView:(THScreenView *)screenView searchEventWithDict:(NSDictionary *)dict;
/** 点击重置、确定调用的方法，将数据带出*/
- (void)screenView:(THScreenView *)screenView searchEventWithDict:(NSDictionary *)dict reset:(BOOL)reset;
@end

@interface THScreenView : UIView
///初始化方法
- (id)initWithFrame:(CGRect)frame style:(THScreenViewStyle)style;
///代理
@property (nonatomic, assign) id<THScreenViewDelegate> delegate;
///给vc添加侧滑功能
- (void)addPanEventWithVC:(UIViewController *)viewController;
///弹窗打开，添加到keyWindow上
- (void)show;
///弹窗打开，添加到目标view上
- (void)showInView:(UIView *)view;
///关闭弹窗
- (void)close;
///初始化，设置完数据源后调用
- (void)reloadData;
///刷新某一个cell
- (void)reloadCellWith:(NSInteger)index;
///触发确认筛选事件
- (void)simulationSubmitBttonClick;
@end

NS_ASSUME_NONNULL_END
