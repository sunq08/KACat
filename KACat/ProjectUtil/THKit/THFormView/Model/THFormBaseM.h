//
//  THFormBaseM.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THFormBaseM : NSObject
+ (instancetype)cellModelWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
///<唯一标识符(更新会用到)
@property (nonatomic,   copy, readonly) NSString *identifier;
///<该模型绑定的cell类名
@property (nonatomic,   copy, readonly) NSString *cellClass;
///<标题
@property (nonatomic,   copy) NSString *title;
///<获取值，返回@{identifier:value}
@property (nonatomic, strong, readonly) NSDictionary *data;
///<内容
@property (nonatomic,   copy) NSString *value;
///<控制禁止编辑
@property (nonatomic, assign) BOOL disable;
///<是否必填，默认为否
@property (nonatomic, assign) BOOL mustIn;
///<是否参与最终的汇总，默认为yes，用于纯展示数据
@property (nonatomic, assign) BOOL joinSummary;
///<校验内容,返回报错信息,为空的话则是验证通过,目前只支持input类型
- (NSString *)validFormCell;
@end

NS_ASSUME_NONNULL_END
