//
//  THScreenMultiSelectM.m
//  GYSA
//
//  Created by itonghui on 2019/10/25.
//  Copyright © 2019 itonghui. All rights reserved.
//

#import "THScreenMultiSelectM.h"

@implementation THScreenMultiSelectM
- (NSString *)cellClass{
    return @"THScreenMultiSelectCell";
}
-(void)setPickerData:(NSMutableArray<NSDictionary *> * )pickerData WithLevel:(NSInteger)level{
    switch (level) {
        case 1:
            _pickerData = pickerData;
            _pickerData2 = [NSMutableArray new];
            _pickerData3 = [NSMutableArray new];
            break;
        case 2:
            _pickerData2 = pickerData;
            _pickerData3 = [NSMutableArray new];
            break;
        case 3:
            _pickerData3 = pickerData;
            break;
        default:
            NSLog(@"THScreenMultiSelectM:level赋值错误，请检查！");
            break;
    }
}
- (NSDictionary *)data{
    NSString *value = (self.value)?self.value:@"";
    NSArray *values = [value componentsSeparatedByString:@","];
    NSString *identifier = (self.identifier)?self.identifier:@"";
    NSArray *identifiers = [identifier componentsSeparatedByString:@","];
    
    NSMutableDictionary *result = [NSMutableDictionary new];
    if (identifiers.count == values.count) {
        for (int i = 0; i< values.count; i++) {
            [result setObject:values[i] forKey:identifiers[i]];
        }
    }else{
        NSLog(@"identifiers命名错误，请使用xxxx,xxxx命名");
        for (int i = 0; i< identifiers.count; i++) {
            [result setObject:@"" forKey:identifiers[i]];
        }
    }
    return result;
}
- (void)reloadCellWithDict:(NSDictionary *)dict{
    [super reloadCellWithDict:dict];
    
    NSMutableArray *pickData = [dict objectForKey:@"pickData"];
    if(pickData && [pickData count]!=0){
        self.pickerData = pickData;
        self.pickerData2 = [NSMutableArray new];
        self.pickerData3 = [NSMutableArray new];
    }
}
- (void)resetValue{
    [super resetValue];
    self.pickerData2 = [NSMutableArray new];
    self.pickerData3 = [NSMutableArray new];
}
@end
