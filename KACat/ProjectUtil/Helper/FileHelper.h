//
//  FileHelper.h
//  TYAPP
//
//  Created by SunQ on 2018/1/26.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DownloadPath @"downloadFiles"

@interface FileHelper : NSObject

/** 获取沙盒路径*/
+ (NSString *)getDocumentFilePath;

/** 判断文件夹是否存在 参数1：文件位置 参数2：文件名*/
+ (BOOL)existFile:(NSString *)fatherPath fileName:(NSString *)fileName;

/** 创建文件夹，会先判断该目录下是否存在同名文件夹，不存在才会创建,并且返回子文件夹路径*/
+ (NSString *)creatDirectory:(NSString *)fatherPath dirctoryName:(NSString *)dirctoryName;
@end
