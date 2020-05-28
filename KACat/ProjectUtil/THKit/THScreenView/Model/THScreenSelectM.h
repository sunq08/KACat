//
//  THScreenSelectM.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THScreenSelectM : THScreenBaseM
/** 选择框的数据源 dic:key为最终提交的值，val为界面显示的值*/
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pickerData;
@end

NS_ASSUME_NONNULL_END
