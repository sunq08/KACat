//
//  THScreenDateM.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenDateM.h"

@implementation THScreenDateM
- (NSString *)cellClass{
    return @"THScreenDateCell";
}
- (NSDictionary *)data{
    NSString *value = (self.value)?self.value:@"";
    NSArray *values = [value componentsSeparatedByString:@","];
    
    NSString *identifier = (self.identifier)?self.identifier:@"";
    NSArray *identifiers = [identifier componentsSeparatedByString:@","];
    
    if(!self.openFormat && !self.openRange){//单个选择时间
        return @{self.identifier:value};
    }
    if(self.openFormat && !self.openRange){//开启自定义&&选择单个时间
        if(identifiers.count<2){
            NSLog(@"identifiers命名错误，请使用xxxx,xxxx命名");
            return @{self.identifier:@""};
        }else{
            NSString *start = values[0];
            NSString *type = (values.count>1)?values[1]:@"";
            return @{identifiers[0]:start,identifiers[1]:type};
        }
    }
    if(!self.openFormat && self.openRange){//未开启自定义&&选择时间范围
        if(identifiers.count<2){
            NSLog(@"identifiers命名错误，请使用xxxx,xxxx命名");
            return @{self.identifier:@""};
        }else{
            NSString *start = values[0];
            NSString *end = (values.count>1)?values[1]:@"";
            return @{identifiers[0]:start,identifiers[1]:end};
        }
    }
    if(self.openFormat && self.openRange){//开启自定义&&选择时间范围
        if(identifiers.count<3){
            NSLog(@"identifiers命名错误，请使用xxxx,xxxx,xxxx命名");
            return @{self.identifier:@""};
        }else{
            NSString *start = values[0];
            NSString *end = (values.count>1)?values[1]:@"";
            NSString *type = (values.count>2)?values[2]:@"";
            return @{identifiers[0]:start,identifiers[1]:end,identifiers[2]:type};
        }
    }
    return @{};
}
- (void)reloadCellWithDict:(NSDictionary *)dict{
    [super reloadCellWithDict:dict];
}
- (void)resetValue{
    [super resetValue];
}
@end
