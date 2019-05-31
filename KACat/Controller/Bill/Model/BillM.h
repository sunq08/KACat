//
//  BillM.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/16.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "JSONModel.h"

@interface BillS : JSONModel

@property (nonatomic,assign) NSInteger  pkid;
@property (nonatomic,strong) NSString   *start_time;
@property (nonatomic,strong) NSString   *end_time;;

@end

@interface BillM : JSONModel

@property (nonatomic,assign) NSInteger  pkid;

@property (nonatomic,assign) NSInteger  type;           //类型，0支出，1收入

@property (nonatomic,assign) double     amount;         //金额
@property (nonatomic,strong) NSData     *image;         //图片

@property (nonatomic,strong) NSString   *class_name;    //分类名
@property (nonatomic,assign) NSInteger  class_id;       //分类id

@property (nonatomic,strong) NSString   *account;       //账户名
@property (nonatomic,assign) NSInteger  account_id;     //账户id

@property (nonatomic,strong) NSDate     *time;          //花钱的时间

@property (nonatomic,strong) NSDate     *add_time;       //添加时间
@property (nonatomic,strong) NSDate     *oper_time;      //操作时间

@property (nonatomic,strong) NSString   *remark;        //备注
@end
