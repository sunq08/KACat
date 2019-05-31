//
//  Helper.m
//  SunQDemo
//
//  Created by SunQ on 2017/6/2.
//  Copyright © 2017年 SunQ. All rights reserved.
//  常用方法封装

#import "Helper.h"
#import "sys/utsname.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#import <WebKit/WebKit.h>

static Helper *sectionInstance;
@implementation Helper

+ (Helper *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionInstance = [[self alloc] init];
    });
    return sectionInstance;
}

#pragma mark - 拨打电话
+ (void)makePhoneCallWithTelNumber:(NSString *)tel {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
}

#pragma mark - 直接打开网页
+ (void)openURLWithUrlString:(NSString *)url {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]]];
}

#pragma mark - 当前界面截图
+ (UIImage *)imageFromCurrentView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC{
    UIViewController* result = nil;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray* windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController* appRootVC = window.rootViewController;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView* frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UIWindow class]])
    {
        UITabBarController* tabbar =  (UITabBarController *)appRootVC;
        UINavigationController* nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
    }
    else if ([nextResponder isKindOfClass:[UITabBarController class]]){
        
        UITabBarController* tabbar = (UITabBarController *)nextResponder;
        UINavigationController* nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    } else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
    } else {
        
        result = nextResponder;
    }
    return result;
}

#pragma mark - 生成随机数 n到m
+(int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to-from + 1)));
}

#pragma mark - 获取用户手机信息
/**  获取手机品牌型号*/
+ (NSString *)getUserPhoneModelNumber {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}
/**  获取手机系统版本*/
+ (NSString *)getPhoneVersion{
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    return phoneVersion;
}
/**  获取app版本号 1.0.1 */
+ (NSString *)getAPPVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}
/**  手机序列号（设备号）*/
+ (NSString *)getIdentifierNumber{
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return identifierNumber;
}
/** 获取设备IP地址 */
+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {                     // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }     // Free memory
    freeifaddrs(interfaces);
    return address;
}

#pragma mark - 字典转化成字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark -  倒计时按钮 返回重置时间
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle disposeButton:(UIButton *)button{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - 获取自适应的webview config
+ (WKWebViewConfiguration *)getWKWebViewConfig{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1,maximum-scale=1, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta); for(i=0;i <document.images.length;i++){document.images[i].setAttribute('style','max-width:100%;')} for(i=0;i <document.getElementsByTagName('video').length;i++){document.getElementsByTagName('video')[i].setAttribute('style','max-width:100%;')} for(i=0;i <document.getElementsByTagName('p').length;i++){document.getElementsByTagName('p')[i].setAttribute('style','word-break:break-all;')}";
    
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    return wkWebConfig;
}

#pragma mark - 背景后退动画效果
//后退动画效果
+ (void)backGroundAnimationShowWith:(UIView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        CALayer *layer = view.layer;
        layer.zPosition = -4000;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -500;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, 6.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeScale(0.9, 0.94);
        }];
    }];
}

//复原动画效果
+ (void)backGroundAnimationHideWith:(UIView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        CALayer *layer = view.layer;
        layer.zPosition = -4000;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500;
        layer.transform = CATransform3DRotate(rotationAndPerspectiveTransform, -6.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}
// 获取设备型号然后手动转化为对应名称
+ (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])
        return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])
        return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])
        return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])
        return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])
        return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])
        return @"美版、台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])
        return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])
        return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])
        return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])
        return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])
        return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])
        return @"美版(Global/A1901)iPhone X";
    if ([deviceString isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])
        return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])
        return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])
        return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])
        return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])
        return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])
        return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])
        return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])
        return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])
        return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])
        return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])
        return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])
        return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])
        return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])
        return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])
        return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])
        return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])
        return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])
        return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])
        return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])
        return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])
        return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])
        return @"iPad Pro 10.5 inch (Cellular)";
    if ([deviceString isEqualToString:@"AppleTV2,1"])    return @"Apple TV 2";   if ([deviceString isEqualToString:@"AppleTV3,1"])    return @"Apple TV 3";   if ([deviceString isEqualToString:@"AppleTV3,2"])    return @"Apple TV 3";   if ([deviceString isEqualToString:@"AppleTV5,3"])    return @"Apple TV 4";    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

@end
