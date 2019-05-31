//
//  FileHelper.m
//  TYAPP
//
//  Created by SunQ on 2018/1/26.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper

+ (NSString *)getDocumentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (BOOL)existFile:(NSString *)fatherPath fileName:(NSString *)fileName{
    NSString *filePath = [fatherPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (NSString *)creatDirectory:(NSString *)fatherPath dirctoryName:(NSString *)dirctoryName{
    NSString *filePath = [fatherPath stringByAppendingPathComponent:dirctoryName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if(isDir == YES && existed == YES){//目标路径下存在文件夹，啥都不用做
        return filePath;
    }
    //文件夹不存在,创建一个
    [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    return filePath;
}
@end
