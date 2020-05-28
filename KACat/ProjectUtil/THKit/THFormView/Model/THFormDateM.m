//
//  THFormDateM.m
//  QIAQIA
//
//  Created by 孙强 on 2020/4/8.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "THFormDateM.h"

@implementation THFormDateM
- (NSString *)cellClass{
    return @"THFormDateCell";
}
- (NSString *)validFormCell{
    if(self.mustIn && [self.value isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@不能为空！",self.title];
    }
    return @"";
}
- (NSDictionary *)data{
    return @{self.identifier:self.value?self.value:@""};
}
@end
