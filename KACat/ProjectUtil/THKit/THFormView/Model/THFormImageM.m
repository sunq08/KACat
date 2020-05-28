//
//  THFormImageM.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormImageM.h"

@implementation THFormImageM
- (NSString *)cellClass{
    return @"THFormImageCell";
}
- (NSString *)validFormCell{
    if(self.mustIn && [self.value isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@不能为空！",self.title];
    }
    return @"";
}
- (NSDictionary *)data{
    if(self.joinSummary){
        return @{self.identifier:self.ids};
    }
    return @{};
}

- (NSMutableArray *)urls{
    if(!_urls){
        _urls = [NSMutableArray arrayWithCapacity:0];
    }
    return _urls;
}
- (NSMutableArray *)ids{
    if(!_ids){
        _ids = [NSMutableArray arrayWithCapacity:0];
    }
    return _ids;
}
@end
