//
//  THScreenCardM.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenCardM.h"

@implementation THScreenCardM
- (NSString *)cellClass{
    return @"THScreenCardCell";
}
- (NSDictionary *)data{
    return @{self.identifier:self.value?self.value:@""};
}
- (void)reloadCellWithDict:(NSDictionary *)dict{
    [super reloadCellWithDict:dict];
    
    NSMutableArray *pickData = [dict objectForKey:@"pickData"];
    if(pickData && [pickData count]!=0){
        self.pickerData = pickData;
    }
}
- (void)resetValue{
    [super resetValue];
}
- (CGFloat)getCardViewHeightWithSupW:(CGFloat)width{
    CGFloat height = 44.0;
    
    NSInteger count = 0;
    if(self.pickerData){//没有data，并且有全部按钮的话，数量加1
        count += self.pickerData.count;
    }
    if(self.allbtn){
        count += 1;
    }
    NSInteger singleNum = (self.singleNum == 0)?4:self.singleNum;
    NSInteger row = ceil(count/(singleNum*1.0f));//向上取整
    height += (row*36);
    return height;
}
@end
