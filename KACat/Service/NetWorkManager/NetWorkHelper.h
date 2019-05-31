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

#pragma mark - 返回CommonM,提交操作可用
+ (void)POST:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure;

+ (void)GET:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure;

#pragma mark - 返回objc,列表可用，不含HUD
+ (void)HttpPOST:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure;

+ (void)HttpGET:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure;

#pragma mark - 返回objc,含有HUD
+ (void)HUDPOST:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure;

+ (void)HUDGET:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure;

@end

