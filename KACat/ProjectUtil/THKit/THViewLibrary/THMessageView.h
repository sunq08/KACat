//
//  THMessageView.h
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//  基本信息展示view，主要是文本显示的问题，支持返回行高 未完成

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** 类型的枚举*/
typedef enum THMessageViewType {
    THTextMessageTypePlain          = 0,        //text
    THTextMessageTypeHtmlText       = 1,        //html string
}THMessageViewType;
@interface THMessageView : UIView
/** @@初始化方法*/
+ (instancetype)messageViewType:(THMessageViewType)messageViewType;
- (instancetype)initWithFrame:(CGRect)frame type:(THMessageViewType)messageViewType;


/** @@title interface*/

/** 标题内容*/
@property (nonatomic,   copy) NSString *title;
/** 文字内容*/
@property (nullable, nonatomic, copy) NSString *text;

/** 标题宽度，默认值在.m文件中修改*/
@property (nonatomic, assign) CGFloat titleWidth;
/** 标题对齐方式，默认左对齐*/
@property (nonatomic) NSTextAlignment titleAlign;

/** 详细信息的行数，默认0*/
@property(nonatomic) NSInteger numberOfLines;

/** 隐藏下边线，默认为NO*/
@property (nonatomic) BOOL hideLine;

/** 获取view高度*/
- (CGFloat)getViewHeight;
@end

NS_ASSUME_NONNULL_END
