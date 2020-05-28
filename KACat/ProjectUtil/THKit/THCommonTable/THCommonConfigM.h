//
//  THCommonConfigM.h
//  QIAQIA
//
//  Created by 孙强 on 2020/4/6.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum THCommonConfigStyle {//卡片样式
    THCommonConfigPlain         = 0,//普通样式
    THCommonConfigCard          = 1,//卡片视图，带圆角
}THCommonConfigStyle;
@interface THCommonConfigM : NSObject
@property (nonatomic, assign) THCommonConfigStyle style;  //卡片样式
@property (nonatomic, assign) NSInteger contentNumber;  //共有多少个内容行，默认为0
@property (nonatomic, assign) BOOL      openDouble;     //双行还是单行
@property (nonatomic, assign) BOOL      hasSign;        //是否有图标
@property (nonatomic, assign) CGSize    signSize;       //图标尺寸
@property (nonatomic, strong) NSArray   *buttonList;    //按钮数组
@end
@interface THDataConfigM : NSObject
@property (nonatomic, strong) UIImage   *sign;          //图标
@property (nonatomic,   copy) NSString  *title;         //标题
@property (nonatomic,   copy) NSString  *subTitle;      //副标题
@property (nonatomic, strong) UIColor   *subTitleColor; //副标题颜色
@property (nonatomic, strong) NSArray <NSString *>*contents;//内容数组
@property (nonatomic, strong) NSArray <NSString *>*buttons; //按钮数组，存储id
@end
NS_ASSUME_NONNULL_END
