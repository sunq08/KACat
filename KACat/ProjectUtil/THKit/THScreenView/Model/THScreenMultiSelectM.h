//
//  THScreenMultiSelectM.h
//  GYSA
//
//  Created by itonghui on 2019/10/25.
//  Copyright © 2019 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THScreenMultiSelectM : THScreenBaseM
/** 一级选择框的数据源 dic:key为最终提交的值，val为界面显示的值*/
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pickerData;
/** 二级选择框的数据源 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pickerData2;
/** 三级选择框的数据源 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *pickerData3;

/** 列数（暂时只支持2级和3级）*/
@property (nonatomic, assign) NSInteger columnCount;
/** 筛选框数据源，根据等级赋值*/
-(void)setPickerData:(NSMutableArray<NSDictionary *> * )pickerData WithLevel:(NSInteger)level;
@end

NS_ASSUME_NONNULL_END
