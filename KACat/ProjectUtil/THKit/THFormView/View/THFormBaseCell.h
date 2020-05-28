//
//  THFormBaseCell.h
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THKitConfig.h"
NS_ASSUME_NONNULL_BEGIN
@class THFormBaseM;
@interface THFormBaseCell : UIView
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel;
///<唯一标识符(更新会用到)
@property (nonatomic,  copy, readonly) NSString *identifier;
///<是否显示必填标识，默认为否
@property (nonatomic, assign) BOOL mustSign;
///<刷新
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
