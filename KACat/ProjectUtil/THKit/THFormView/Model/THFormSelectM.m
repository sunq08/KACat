//
//  THFormSelectM.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormSelectM.h"

@implementation THFormSelectM
- (NSString *)cellClass{
    return @"THFormSelectCell";
}
- (NSString *)validFormCell{
    if(self.mustIn && [self.value isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@不能为空！",self.title];
    }
    return @"";
}
- (NSDictionary *)data{
    if(self.joinSummary){
        return @{self.identifier:self.value?self.value:@""};
    }
    return @{};
}
@end
