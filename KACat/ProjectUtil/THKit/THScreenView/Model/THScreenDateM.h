//
//  THScreenDateM.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THScreenDateM : THScreenBaseM
@property (nonatomic, assign) BOOL      openFormat;
@property (nonatomic, assign) BOOL      openRange;

///<默认选择类型，0秒 1分 2时 3天 4月 5年, 默认是0
@property (nonatomic, assign) NSInteger defaultFormat;
///<选择范围的范围宽度，openFormat=yes时有效，0秒 1分 2时 3天 4月 5年, 默认是0
@property (nonatomic, assign) NSInteger formatRange;
@end

NS_ASSUME_NONNULL_END
