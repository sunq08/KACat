//
//  THFormView.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THFormBaseM.h"
#import "THFormTextM.h"
#import "THFormSwitchM.h"
#import "THFormSelectM.h"
#import "THFormImageM.h"
#import "THFormDateM.h"
NS_ASSUME_NONNULL_BEGIN
@class THFormView;
///<数据源代理方法
@protocol THFormViewDelegate <NSObject>
@required
///<共有多少行
- (NSInteger)numberOfIndexInFormView:(THFormView *)formView;
///<配置cell信息
- (THFormBaseM *)formView:(THFormView *)formView cellModelForIndex:(NSInteger)index;
@optional
///<点击确定调用的方法，将数据带出
- (void)formView:(THFormView *)formView didSubmitClick:(NSMutableDictionary *)dict;
///<设置按钮样式
- (void)formView:(THFormView *)formView buttonStyle:(UIButton *)sender;
@end
@interface THFormView : UIView
///<是否显示必填标识，默认为否
@property (nonatomic, assign) BOOL mustSign;
///<代理
@property (nonatomic, assign) id<THFormViewDelegate> delegate;
///<刷新
- (void)reloadData;
///<刷新某一个cell，用于修改标题/cell的数据源
- (void)reloadCellWith:(NSInteger)index;
///<数据校验,返回报错信息,为空则表示校验通过
- (NSString *)validForm;
///<全局控制每个项目的禁止编辑/允许编辑，优先级大于单个设置cell的编辑模式，暂未实现
- (void)setDisable:(BOOL)disable;
@end

NS_ASSUME_NONNULL_END
