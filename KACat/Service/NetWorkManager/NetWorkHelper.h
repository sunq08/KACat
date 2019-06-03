//
//  NetWorkHelper.h
//  SunQDemo
//
//  Created by SunQ on 2017/6/26.
//  Copyright © 2017年 SunQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetAPI.h"
#import "CommonM.h"
typedef void (^ModelBlock)(JSONModel* aModelBaseObject);// 请求成功回调
typedef void (^objcBlock)(id objc);// 请求成功回调
typedef void(^failuerBlock)(id error);// 请求失败回调
typedef void(^uploadProgress)(float progress);//上传进度回调

@interface NetWorkHelper : NSObject

#pragma mark - 基础请求方法，快捷请求不能满足业务时请使用本方法
+ (void)request:(NSString *)url type:(NSString *)type parameters:(id)parameters hud:(BOOL)hud success:(objcBlock)success failure:(failuerBlock)failure;

#pragma mark - 返回CommonM,提交操作可用，含hud
+ (void)POST:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure;

#pragma mark - 返回CommonM,提交操作可用，不含HUD
+ (void)GET:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure;

#pragma mark - 自动登录
+ (void)tkLoginWithSuccess:(objcBlock)success;

@end

