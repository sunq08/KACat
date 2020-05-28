//
//  THFormSwitchM.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormSwitchM.h"

@implementation THFormSwitchM
- (NSString *)cellClass{
    return @"THFormSwitchCell";
}
- (NSString *)validFormCell{
    //开关肯定有值
    return @"";
}
- (NSDictionary *)data{
    if(self.joinSummary){
        return @{self.identifier:self.value?self.value:@""};
    }
    return @{};
}
@end
