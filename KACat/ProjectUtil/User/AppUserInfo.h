//
//  AppUserInfo.h
//  V60-OnlineMart
//
//  Created by 任芳 on 2017/2/8.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface AppUserInfo : NSObject

singleton_interface(AppUserInfo);

@property (nonatomic, assign) BOOL isLogin; //登录状态

//存储用户名
+(void)setCacheUserName:(NSString *)userName;
+(NSString*)getCacheUserName;

//存储tk
+(void)setCacheTK:(NSString *)tk;
+(NSString*)getCacheTK;
+(void)removeCacheTK;

//弹出登录页面
+ (void)presentLoginVC;

//缓存检索历史数据
+ (void)setCatchSearchHistory:(NSMutableArray *)SearchHistory;
+ (NSMutableArray *)getCatchSearchHistory;

@end
