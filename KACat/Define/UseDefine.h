//
//  UseDefine.h
//  HDLY-Project
//
//  Created by SunQ on 2017/7/19.
//  Copyright © 2017年 SunQ. All rights reserved.
//

#ifndef UseDefine_h
#define UseDefine_h

//监听事件
#define Notification_LoginEvent     @"NotificationLoginEvent"
#define Notification_HomeReload     @"Notification_HomeReload"


//默认图片
#define PLACEHOLDER_IMAGE [UIImage imageNamed:@"default"]
//字体
#define SYSTEMFONT(a) [UIFont systemFontOfSize:a]
//图片
#define ImageNamed(name) [UIImage imageNamed:name]

#define RootAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define MScreenWidth [UIScreen mainScreen].bounds.size.width
#define MScreenHeight [UIScreen mainScreen].bounds.size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && ScreenHeight == 812.0)

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavBarHeight 44.0
#define TopHeight (StatusBarHeight + NavBarHeight)

// 弱引用
#define WeakSelf __weak typeof(self) weakSelf = self

//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define MLog(...) printf("[%s] [第%d行]: %s\n", __TIME__  ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define MLog(...)
#endif

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]
//日期格式
#define DateFormatD @"yyyy.MM.dd"
#define DateFormatS @"yyyy.MM.dd HH:mm:ss"

//颜色
#define MClearColor [UIColor clearColor]
#define MWhiteColor [UIColor whiteColor]
#define MBlackColor [UIColor blackColor]
#define MGrayColor [UIColor grayColor]
#define MGreenColor [UIColor greenColor]
#define MLightGrayColor [UIColor lightGrayColor]
#define MDarkGrayColor [UIColor darkGrayColor]
#define MBlueColor [UIColor blueColor]
#define MRedColor [UIColor redColor]
#define MTableBgColor [UIColor groupTableViewBackgroundColor]

//数据验证
#define ValidStr(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

#endif /* UseDefine_h */
