//
//  THCardView.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THCardView : UIView
/** 数据源，必传*/
@property (nonatomic, strong) NSArray<NSDictionary *> *pickerData;
/** 每行数量*/
@property (nonatomic, assign) NSInteger           singleNum;
/** 默认值*/
@property (nonatomic,   copy) NSString            *defaultValue;
/** 获取值*/
@property (nonatomic, strong, readonly) NSString  *selectValue;
/** 开启多选*/
@property (nonatomic, assign) BOOL                multiple;
/** 开启全部按钮，全部按钮的传值为@""*/
@property (nonatomic, assign) BOOL                allbtn;
/** 重置*/
- (void)resetValue;
///<监听内容改变，注意弱引用
@property (nonatomic,   copy) void (^valueChanged)(NSString *value);
/** 根据宽度获取卡片大小*/
- (CGFloat)getCardViewHeightWithSupW:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
