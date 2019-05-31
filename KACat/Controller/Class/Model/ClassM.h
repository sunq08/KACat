//
//  ClassM.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "JSONModel.h"

@interface ClassM : JSONModel

@property (nonatomic,assign) NSInteger  pkid;
@property (nonatomic,assign) NSInteger  class_id;
@property (nonatomic,strong) NSString   *class_name;
@property (nonatomic,assign) double     amount;
@property (nonatomic,strong) NSData     *icon;
@property (nonatomic,assign) NSInteger  add_date;

@end
