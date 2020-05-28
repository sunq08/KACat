//
//  THDataM.h
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface THDataM : NSObject
@property (nonatomic,   copy) NSString          *title;
@property (nonatomic,   copy) NSString          *detail;
@property (nonatomic,   copy) NSString          *imgUrl;
@property (nonatomic,   copy) NSMutableArray    *imgUrls;
@property (nonatomic,   copy) NSString          *htmlStr;
@property (nonatomic,   copy) NSString          *url;
@property (nonatomic, assign) NSInteger cellType;//0文字，1图片，2富文本（html文本），3图片数组

@property (nonatomic, assign) NSTextAlignment textAlignment;//
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

/**************************可选参数*****************************/
/** 详细文字颜色*/
@property (nonatomic,strong) UIColor            *detailColor;
/* 创建对象方法，必须用以下方法创建，才能识别数据类型**/
+ (THDataM *)title:(NSString *)title detail:(NSString *)detail;
/* 创建对象方法，必须用以下方法创建，才能识别数据类型**/
+ (THDataM *)title:(NSString *)title imgUrl:(NSString *)imgUrl;
/* 创建对象方法，必须用以下方法创建，才能识别数据类型**/
+ (THDataM *)title:(NSString *)title htmlStr:(NSString *)htmlStr;
/* 创建对象方法，必须用以下方法创建，才能识别数据类型**/
+ (THDataM *)title:(NSString *)title imgUrls:(NSArray <NSString *>*)imgUrls;

@end

NS_ASSUME_NONNULL_END
