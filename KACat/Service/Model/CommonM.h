//
//  CommonM.h
//  OnlineMart
//
//  Created by wdl on 14-8-8.
//  Copyright (c) 2014年 wdl. All rights reserved.
//

#import "JSONModel.h"

@interface CommonM : JSONModel
@property (nonatomic , assign) NSInteger     code;
@property (nonatomic , strong) NSString     *msg;
@end
