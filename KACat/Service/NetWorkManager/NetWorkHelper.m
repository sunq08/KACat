//
//  NetWorkHelper.m
//  SunQDemo
//
//  Created by SunQ on 2017/6/26.
//  Copyright © 2017年 SunQ. All rights reserved.
//

#import "NetWorkHelper.h"
#import "NetWorkManager.h"
@implementation NetWorkHelper

#pragma mark - 公共方法
+ (void)POST:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure{
    [HUDManager showLoading];
    [NetWorkManager POST:url params:parameters success:^(id objc) {
        [HUDManager hideHUD];
        CommonM *model = [[CommonM alloc]initWithDictionary:objc];
        success(model);
    } failure:^(id error) {
        [HUDManager hideHUD];
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)GET:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure{
    [HUDManager showLoading];
    [NetWorkManager GET:url params:parameters success:^(id objc) {
        [HUDManager hideHUD];
        CommonM *model = [[CommonM alloc]initWithDictionary:objc];
        success(model);
    } failure:^(id error) {
        [HUDManager hideHUD];
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)HttpPOST:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure{
    [NetWorkManager POST:url params:parameters success:^(id objc) {
        success(objc);
    } failure:^(id error) {
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)HttpGET:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure{
    [NetWorkManager GET:url params:parameters success:^(id objc) {
        success(objc);
    } failure:^(id error) {
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)HUDPOST:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure{
    [HUDManager showLoading];
    [NetWorkManager POST:url params:parameters success:^(id objc) {
        [HUDManager hideHUD];
        success(objc);
    } failure:^(id error) {
        [HUDManager hideHUD];
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];  
}

+ (void)HUDGET:(NSString *)url parameters:(id)parameters success:(objcBlock)success failure:(failuerBlock)failure{
    [HUDManager showLoading];
    [NetWorkManager GET:url params:parameters success:^(id objc) {
        [HUDManager hideHUD];
        success(objc);
    } failure:^(id error) {
        [HUDManager hideHUD];
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

@end

