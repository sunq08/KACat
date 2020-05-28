//
//  THDataPresentView.h
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//  基础数据展示布局，类似tablview写法，基于masary sdwebimage 适用于没有操作的展示页面

#import <UIKit/UIKit.h>
#import "THDataM.h"
#import "THDataSectionHead.h"
NS_ASSUME_NONNULL_BEGIN
@class THDataPresentView;

/** 数据源代理方法*/
@protocol THDataPresentViewDelegate <NSObject>
@required
/** 共有多少行*/
- (NSInteger)presentView:(THDataPresentView *)presentView numberOfRowInSection:(NSInteger)section;
/** 配置cell*/
- (THDataM *)presentView:(THDataPresentView *)presentView configCellWithIndexPath:(NSIndexPath *)indexPath;
@optional
/** 共有多少区*/
- (NSInteger)numberOfSectionInPresentView:(THDataPresentView *)presentView;
/** 配置区标题*/
- (void)presentView:(THDataPresentView *)presentView configSectionHeaderForSection:(NSInteger)section view:(THDataSectionHead *)view;
/** 区头高度*/
- (CGFloat)presentView:(THDataPresentView *)presentView heightForHeaderInSection:(NSInteger)section;
/** 点击事件*/
- (void)presentView:(THDataPresentView *)presentView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface THDataPresentView : UIView
/** 代理*/
@property (nonatomic, assign) id<THDataPresentViewDelegate> delegate;

/** 头部视图*/
@property (nonatomic, strong) UIView    *presentHeadView;

- (void)reloadData;
- (void)reloadIndexPathDataWithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
