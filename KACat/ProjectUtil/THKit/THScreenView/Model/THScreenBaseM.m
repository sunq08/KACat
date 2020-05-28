//
//  THScreenBaseM.m
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"
@interface THScreenBaseM()
@property (nonatomic,  copy, readwrite) NSString   *identifier;
@end
@implementation THScreenBaseM
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title{
    self = [super init];
    if (self) {
        self.identifier             = identifier;
        self.title                  = title;
    }
    return self;
}
- (instancetype)initWithIdentifier:(NSString *)identifier{
    return [self initWithIdentifier:identifier title:@""];
}
+ (id)cellModelWithIdentifier:(NSString *)identifier;{
    return [self cellModelWithIdentifier:identifier title:@""];
}
+ (id)cellModelWithIdentifier:(NSString *)identifier title:(NSString *)title{
    return [[self alloc]initWithIdentifier:identifier title:title];
}

- (void)resetValue{
    self.value = @"";
}

- (void)reloadCellWithDict:(NSDictionary *)dict{
    NSString *value = [dict objectForKey:@"value"];
    self.value = value?value:@"";
}
@end
