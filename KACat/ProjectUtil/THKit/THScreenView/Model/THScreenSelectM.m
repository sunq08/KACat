//
//  THScreenSelectM.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenSelectM.h"

@implementation THScreenSelectM
- (NSString *)cellClass{
    return @"THScreenSelectCell";
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

@end
