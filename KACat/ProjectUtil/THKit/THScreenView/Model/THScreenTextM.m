//
//  THScreenTextM.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenTextM.h"
@interface THScreenTextM()
@end
@implementation THScreenTextM


- (NSString *)cellClass{
    return @"THScreenTextCell";
}

- (void)resetValue{
    [super resetValue];
    
    if(self.actionBlock){
        self.actionText = @"";
    }
}

- (void)reloadCellWithDict:(NSDictionary *)dict{
    [super reloadCellWithDict:dict];
    NSString *text = [dict objectForKey:@"text"];
    self.actionText = text?text:@"";
}

- (NSDictionary *)data{
    if (self.openRange) {//范围输入，拼接value
        NSArray *identifiers = [self.identifier componentsSeparatedByString:@","];
        NSArray *values = (self.value)?[self.value componentsSeparatedByString:@","]:@[@"",@""];
        if(identifiers.count<2){
            NSLog(@"identifiers命名错误，请使用xxxx,xxxx命名");
        }else{
            NSString *valueSecond = (values.count>1)?values[1]:@"";
            return @{identifiers[0]:values[0],identifiers[1]:valueSecond};
        }
    }

    //单个输入，直接返回value
    return @{self.identifier:self.value?self.value:@""};
}

@end
