//
//  THScreenBaseM.h
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface THScreenBaseM : NSObject
///<快速创建
- (instancetype)initWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title;
+ (id)cellModelWithIdentifier:(NSString *)identifier;
+ (id)cellModelWithIdentifier:(NSString *)identifier title:(NSString *)title;

///<唯一标识符(更新会用到)
@property (nonatomic,  copy, readonly) NSString *identifier;
///<该模型绑定的cell类名
@property (nonatomic,  copy, readonly) NSString *cellClass;
///<标题
@property (nonatomic,   copy) NSString *title;
///<监听内容改变，注意弱引用，暂未实现
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);
///<值，通过cell赋值进来，用于拼接data
@property (nonatomic,   copy) NSString *value;
///<必填标识
@property (nonatomic, assign) BOOL mustSign;
///<获取值，返回@{identifier:value}
@property (nonatomic, strong, readonly) NSDictionary *data;
///<重置value
- (void)resetValue;
///<刷新cell内容,dict包含info内容，可选：text，value
- (void)reloadCellWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
