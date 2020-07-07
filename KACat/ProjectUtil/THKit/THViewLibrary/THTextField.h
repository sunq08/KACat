//
//  THTextField.h
//  GYSA
//
//  Created by SunQ on 2019/8/26.
//  Copyright © 2019年 itonghui. All rights reserved.
//  通用textfiled视图，左边可以是icon，也可以是title

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THTextField : UITextField
/** 快捷创建arrowCell*/
+ (instancetype)textField;
/** 需要限制的字数*/
@property (nonatomic,  copy) NSNumber *limitLength;

@end

NS_ASSUME_NONNULL_END
