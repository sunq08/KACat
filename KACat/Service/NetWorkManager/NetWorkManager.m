//
//  NetWorkManager.m
//  SunQDemo
//
//  Created by SunQ on 2017/6/6.
//  Copyright © 2017年 SunQ. All rights reserved.
//

#import "NetWorkManager.h"
#import "NetAPI.h"
#import "AFNetworkActivityIndicatorManager.h"
@interface NetWorkManager()

@end

static BOOL _canLog;
static NSMutableArray *_allSessionTask;

#define NetLog(...) printf("[%s] : %s\n", __TIME__ , [[NSString stringWithFormat:__VA_ARGS__] UTF8String])

@implementation NetWorkManager
+ (instancetype)sharedManager {
    static NetWorkManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *urlStr = [NSString stringWithFormat:@"%@",URL_Base];
        manager = [[self alloc]initWithBaseURL:[NSURL URLWithString:urlStr]];
    });
    return manager;
}


-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        /**设置是否允许打印*/
        _canLog = YES;
        /**设置请求超时时间*/
        self.requestSerializer.timeoutInterval = kTime;
        
        /**设置相应的缓存策略*/
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        [self.requestSerializer setValue:@"iPhone" forHTTPHeaderField:@"user-agent"];
        
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        response.removesKeysWithNullValues = YES;
        self.responseSerializer = response;
        
        // 是否信任 非法证书
        self.securityPolicy.allowInvalidCertificates = YES;
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
    return self;
}


- (void)openJson {
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",nil];
}

- (void)closeJson {
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",nil];
}

#pragma mark - 开始监听网络连接

+ (void)startMonitoring{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status){
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                if(_canLog) NSLog(@"未知网络");
                [NetWorkManager sharedManager].networkStats =  StatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                if(_canLog) NSLog(@"没有网络");
                [NetWorkManager sharedManager].networkStats=StatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                if(_canLog) NSLog(@"手机自带网络");
                [NetWorkManager sharedManager].networkStats=StatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                [NetWorkManager sharedManager].networkStats=StatusReachableViaWiFi;
                if(_canLog) NSLog(@"WIFI");
                break;
        }
    }];
    [mgr startMonitoring];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask {
    if (!_allSessionTask) {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}

#pragma mark - 请求类

+ (void) GET:(NSString *)urlStr params:(id)params success:(successBlock)success failure:(failureBlock)failure{
    NSURLSessionTask *sessionTask = [[NetWorkManager sharedManager] GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        if(_canLog) NetLog(@"请求成功 --- %@",task.currentRequest.URL);
        if(_canLog) NetLog(@"successPrint = %@",[self toJSONStringForDictionary:responseObject]);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        if(_canLog) NetLog(@"请求失败 --- %@",task.currentRequest.URL);
        failure(error);
    }];
    if (sessionTask) [[self allSessionTask] addObject:sessionTask];
}

+ (void) POST:(NSString *)urlStr params:(id)params success:(successBlock)success failure:(failureBlock)failure{
    NSURLSessionTask *sessionTask = [[NetWorkManager sharedManager] POST:urlStr parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        if(_canLog) NetLog(@"请求成功 --- %@",task.currentRequest.URL);
        if(_canLog) NetLog(@"successPrint = %@",[self toJSONStringForDictionary:responseObject]);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        if(_canLog) NetLog(@"请求失败 --- %@",task.currentRequest.URL);
        failure(error);
    }];

    if (sessionTask) [[self allSessionTask] addObject:sessionTask];
}

+ (NSString *)toJSONStringForDictionary:(NSMutableDictionary *)dict{
    if(dict!=nil && [dict isKindOfClass:[NSDictionary class]]){
        NSData *paramsJSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        return [[NSString alloc] initWithData:paramsJSONData encoding:NSUTF8StringEncoding];
    }
    return @"";
}

#pragma mark - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param path   上传的图片数组
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations withPath:(NSString *)path withUrlString:(NSString *)urlString withSuccessBlock:(successBlock)successBlock withFailurBlock:(failureBlock)failureBlock withUpLoadProgress:(uploadProgress)progress;
{
    //1.创建管理者对象
    [[AFHTTPSessionManager manager] POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" error:&error];
        (failureBlock && error) ? failureBlock(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        if(_canLog) NetLog(@"请求成功 --- %@",task.currentRequest.URL);
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(_canLog) NetLog(@"请求失败 --- %@",task.currentRequest.URL);
        failureBlock(error);
    }];
}

+ (void)downLoadWithURLString:(NSString *)URLString tagePath:(NSString *)tagePath progerss:(downloadProgress)progress success:(successBlock)success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:tagePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (success) success(success);
    }];
    [downLoadTask resume];
}



// MARK:  =========  取消全部的网络请求  =========

+ (void)cancelAllRequest {
    // 锁操作
    @synchronized(self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL {
    if (!URL) { return; }
    @synchronized (self) {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}


@end
