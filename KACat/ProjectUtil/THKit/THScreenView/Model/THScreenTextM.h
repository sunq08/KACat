//
//  THScreenTextM.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN
@class THScreenTextM;
typedef void(^ClickActionBlock)(NSString *identifier);

@interface THScreenTextM : THScreenBaseM
///<input点击事件,设置这个参数将是input变成一个按钮，无法输入，只能做点击事件
@property (nonatomic,   copy) ClickActionBlock actionBlock;
///<输入框最大数量，默认为0，不限制
@property (nonatomic, assign) NSInteger maxLength;
///<范围模式
@property (nonatomic, assign) BOOL     openRange;
///<点击模式下，展示的问题
@property (nonatomic,   copy) NSString  *actionText;
@end

NS_ASSUME_NONNULL_END
