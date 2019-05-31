//
//  AccountM.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/10.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "JSONModel.h"

@interface AccountM : JSONModel

@property (nonatomic,assign) NSInteger  pkid;
@property (nonatomic,strong) NSString   *name;
@property (nonatomic,assign) double     amount;
@property (nonatomic,strong) NSString   *remark;
@property (nonatomic,strong) NSData     *icon;

@end
