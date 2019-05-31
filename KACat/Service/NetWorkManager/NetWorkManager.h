//
//  NetWorkManager.h
//  SunQDemo
//
//  Created by SunQ on 2017/6/6.
//  Copyright © 2017年 SunQ. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

// 请求成功回调
typedef void(^successBlock)(id objc);
// 请求失败回调
typedef void(^failureBlock)(id error);
//上传进度回调
typedef void(^uploadProgress)(float progress);
//下载进度回调
typedef void(^downloadProgress)(float progress);

// 网络状态类型
typedef NS_ENUM(NSUInteger, NetworkStatus) {
    StatusUnknown           = -1, //未知网络
    StatusNotReachable      = 0,    //没有网络
    StatusReachableViaWWAN  = 1,    //手机自带网络
    StatusReachableViaWiFi  = 2     //wifi
    
};

// MARK:  =========  设置请求超时时长  =========
#define kTime 7

@interface NetWorkManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

/**
 *  获取网络
 */
@property (nonatomic,assign)NetworkStatus networkStats;

/**
 *  开启网络监测
 */
+ (void)startMonitoring;

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask;

/**
 开启json传参
 */
- (void)openJson;

/**
 关闭json传参
 */
- (void)closeJson;


/**
 AFN 网络请求 GET

 @param urlStr 请求链接
 @param params 参数
 @param success 成功返回
 @param failure 失败数据
 */
+ (void) GET:(NSString *)urlStr params:(id)params success:(successBlock)success failure:(failureBlock)failure;


/**
 AFN 网络请求 POST
 
 @param urlStr 请求链接
 @param params 参数
 @param success 成功返回
 @param failure 失败数据
 */
+ (void) POST:(NSString *)urlStr params:(id)params success:(successBlock)success failure:(failureBlock)failure;

/**
 *  上传图片
 *
 *  @param operations   上传图片预留参数---视具体情况而定 可移除
 *  @param path         上传的图片路径
 *  @param urlString    上传的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 */

+(void)uploadImageWithOperations:(NSDictionary *)operations withPath:(NSString *)path withUrlString:(NSString *)urlString withSuccessBlock:(successBlock)successBlock withFailurBlock:(failureBlock)failureBlock withUpLoadProgress:(uploadProgress)progress;

/**
 *  下载数据
 *
 *  @param URLString    下载数据的网址
 *  @param tagePath     下载目标路径
 *  @param progress     下载进度
 *  @param success      下载成功的回调
 */
+ (void)downLoadWithURLString:(NSString *)URLString tagePath:(NSString *)tagePath progerss:(downloadProgress)progress success:(successBlock)success;

/**
 取消请求
 */
+ (void)cancelAllRequest;


/**
 取消指定url的请求

 @param URL urlstring
 */
+ (void)cancelRequestWithURL:(NSString *)URL;


@end
