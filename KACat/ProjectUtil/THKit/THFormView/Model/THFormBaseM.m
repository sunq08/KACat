//
//  THFormBaseM.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormBaseM.h"
@interface THFormBaseM()
@property (nonatomic,  copy, readwrite) NSString *identifier;
@end
@implementation THFormBaseM
+ (instancetype)cellModelWithIdentifier:(NSString *)identifier{
    return [[self alloc]initWithIdentifier:identifier];
}
- (instancetype)initWithIdentifier:(NSString *)identifier{
    self = [super init];
    if (self) {
        self.identifier = identifier;
        //默认值
        self.joinSummary = YES;
        //赋值为空防止崩溃
        self.value = @"";
        self.title = @"";
    }
    return self;
}

- (NSString *)validFormCell{
    return @"";
}
@end
