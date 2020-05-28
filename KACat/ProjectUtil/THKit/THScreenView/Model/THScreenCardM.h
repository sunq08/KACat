//
//  THScreenCardM.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THScreenCardM : THScreenBaseM
/** 选择框的数据源 dic:key为最终提交的值，val为界面显示的值*/
@property (nonatomic, strong) NSArray<NSDictionary *> *pickerData;

@property (nonatomic, assign) NSInteger singleNum;//每行几个，默认为4
@property (nonatomic, assign) BOOL multiple;//开启多选
@property (nonatomic, assign) BOOL allbtn;//开启全部按钮，全部按钮的传值为@""
- (CGFloat)getCardViewHeightWithSupW:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
