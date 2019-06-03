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

+ (void)request:(NSString *)url type:(NSString *)type parameters:(id)parameters hud:(BOOL)hud success:(objcBlock)success failure:(failuerBlock)failure{
    if ([type isEqualToString:@"get"] || [type isEqualToString:@"GET"]) {
        if(hud) [HUDManager showLoading];
        [NetWorkManager GET:url params:parameters success:^(id objc) {
            if(hud) [HUDManager hideHUD];
            success(objc);
        } failure:^(id error) {
            [HUDManager hideHUD];
            if(failure) failure(error);
        }];
    } else if([type isEqualToString:@"post"] || [type isEqualToString:@"POST"]){
        if(hud) [HUDManager showLoading];
        [NetWorkManager POST:url params:parameters success:^(id objc) {
            if(hud) [HUDManager hideHUD];
            success(objc);
        } failure:^(id error) {
            [HUDManager hideHUD];
            if(failure) failure(error);
        }];
    }
}

#pragma mark - 公共方法
+ (void)POST:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure{
    [self request:url type:@"post" parameters:parameters hud:YES success:^(id objc) {
        CommonM *model = [[CommonM alloc]initWithDictionary:objc];
        success(model);
    } failure:^(id error) {
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)GET:(NSString *)url parameters:(id)parameters success:(ModelBlock)success failure:(failuerBlock)failure{
    [self request:url type:@"get" parameters:parameters hud:YES success:^(id objc) {
        CommonM *model = [[CommonM alloc]initWithDictionary:objc];
        success(model);
    } failure:^(id error) {
        [HUDManager showError:@"网络连接错误"];
        if(failure) failure(error);
    }];
}

+ (void)tkLoginWithSuccess:(objcBlock)success{
    NSString *tk = [AppUserInfo getCacheTK];
    if(!ValidStr(tk)){//不存在tk，直接打开登录页
        [AppUserInfo presentLoginVC];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:[AppUserInfo getCacheTK] forKey:@"atk"];
    [dict setObject:@"6688" forKey:@"sysCode"];
    [self request:URL_Login type:@"post" parameters:dict hud:NO success:^(id objc) {
        CommonM *model = [[CommonM alloc]initWithDictionary:objc];
        if(model.code == NETSUCCESS){//自动登录成功，页面可以选择在回调中刷新
            [AppUserInfo sharedAppUserInfo].isLogin = YES;
            if(ValidStr(model.ext)){
                [AppUserInfo setCacheTK:model.ext];
            }
            if(success) success(objc);
        } else if(model.code == NETUNLOGIN){//tk超时
            [AppUserInfo removeCacheTK];
            [AppUserInfo presentLoginVC];
        }
    } failure:nil];
}

@end

