//
//  THFormTextM.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormTextM.h"
#import "NSString+THFormPredicate.h"
@implementation THFormTextM
- (instancetype)initWithIdentifier:(NSString *)identifier{
    self = [super initWithIdentifier:identifier];
    if (self) {
        self.keyboardType = UIKeyboardTypeDefault;//默认键盘
    }
    return self;
}

- (NSString *)cellClass{
    return @"THFormTextCell";
}

- (NSString *)validFormCell{
    if(self.mustIn && [self.value isEqualToString:@""]){
        return [NSString stringWithFormat:@"%@不能为空！",self.title];
    }
    if((self.validType & THFormTextValidCellPhone) && ![self.value th_isValidateCellPhone]){
        return [NSString stringWithFormat:@"请输入正确的手机号（%@）！",self.title];
    }
    if((self.validType & THFormTextValidNumber) && ![self.value th_isOnlyNumber]){
        return [NSString stringWithFormat:@"%@只能输入数字！",self.title];
    }
    if((self.validType & THFormTextValidNoEmoji) && [self.value th_validateEmoji]){
        return [NSString stringWithFormat:@"%@不能输入表情！",self.title];
    }
    if((self.validType & THFormTextValidAZ09) && ![self.value th_isOnlyAZ09]){
        return [NSString stringWithFormat:@"%@只能输入英文字母或数字！",self.title];
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
