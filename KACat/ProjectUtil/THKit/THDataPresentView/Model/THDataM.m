//
//  THDataM.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataM.h"

@implementation THDataM
+ (THDataM *)title:(NSString *)title detail:(NSString *)detail{
    THDataM *model = [[THDataM alloc]init];
    model.title = title;
    model.detail = detail;
    model.cellType = 0;
    return model;
}
+ (THDataM *)title:(NSString *)title imgUrl:(NSString *)imgUrl{
    THDataM *model = [[THDataM alloc]init];
    model.title = title;
    model.imgUrl = imgUrl;
    model.cellType = 1;
    return model;
}
+ (THDataM *)title:(NSString *)title htmlStr:(NSString *)htmlStr{
    THDataM *model = [[THDataM alloc]init];
    model.title = title;
    model.htmlStr = htmlStr;
    model.cellType = 2;
    return model;
}

+ (THDataM *)title:(NSString *)title imgUrls:(NSArray <NSString *>*)imgUrls{
    THDataM *model = [[THDataM alloc]init];
    model.title = title;
    model.imgUrls = [NSMutableArray arrayWithArray:imgUrls];
    model.cellType = 3;
    return model;
}

- (instancetype)init{
    self = [super init];
    if(self){//设置默认值
        self.accessoryType = UITableViewCellAccessoryNone;
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
@end
