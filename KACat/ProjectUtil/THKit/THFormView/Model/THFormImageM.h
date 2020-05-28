//
//  THFormImageM.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THFormImageM : THFormBaseM
@property (nonatomic, assign) NSInteger maxCount;
/** 点击添加按钮的回调，注意弱引用，返回是否超出最大值*/
@property (nonatomic,   copy) void (^imageAddClick)(BOOL overflow);

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray *ids;
@end

NS_ASSUME_NONNULL_END
