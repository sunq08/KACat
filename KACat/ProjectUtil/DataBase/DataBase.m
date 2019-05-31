//
//  DataBase.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/10.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "DataBase.h"
#import "JQFMDB.h"
#import <FMDB/FMDB.h>

#import "AccountM.h"
#import "ClassM.h"
#import "BillM.h"
static DataBase *_DBCtl = nil;
@interface DataBase()<NSCopying,NSMutableCopying>{
    JQFMDB  *_db;
}

@end
@implementation DataBase

+(instancetype)sharedDataBase{
    if (_DBCtl == nil) {
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initTableBase];
    }
    return _DBCtl;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (_DBCtl == nil) {
        _DBCtl = [super allocWithZone:zone];
    }
    return _DBCtl;
}

-(id)copy{
    return self;
}

-(id)mutableCopy{
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    return self;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return self;
}
#pragma mark - 数据初始化方法
- (void)initTableBase{
    _db = [JQFMDB shareDatabase:@"EasyAccount.db"];
    
    BOOL hasTable = [_db jq_isExistTable:@"t_account"];
    
    // 初始化数据表
    [_db jq_createTable:@"t_account" dicOrModel:[AccountM class]];
    [_db jq_createTable:@"t_class" dicOrModel:[ClassM class]];
    [_db jq_createTable:@"t_bill" dicOrModel:[BillM class]];
    
    if(!hasTable){
        [self addDataBase];
    }
}

-(void)deleteDataBase{
    //清空数据
    [_db jq_deleteAllDataFromTable:@"t_account"];
    [_db jq_deleteAllDataFromTable:@"t_class"];
    [_db jq_deleteAllDataFromTable:@"t_bill"];
    
    [self addDataBase];
}

- (void)addDataBase{
    //初始化数据
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"DataBase" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plist];
    NSArray *e_class = [data objectForKey:@"e_class"];
    NSArray *e_class_backs = [_db jq_insertTable:@"t_class" dicOrModelArray:e_class];
    
    NSArray *i_class = [data objectForKey:@"i_class"];
    NSArray *i_class_backs = [_db jq_insertTable:@"t_class" dicOrModelArray:i_class];
    
    NSArray *account = [data objectForKey:@"account"];
    NSArray *account_backs = [_db jq_insertTable:@"t_account" dicOrModelArray:account];
    
    MLog(@"初始化数据失败数量:%ld",e_class_backs.count + i_class_backs.count + account_backs.count);
}


// 获取当前周的周一和周日的时间
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5",@"6", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

- (void)addChiHeWanLe:(NSMutableArray *)array date:(NSDate *)date{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:date forKey:@"time"];
    [dict setObject:@"请客吃饭" forKey:@"class_name"];
    [dict setObject:@(100105100) forKey:@"class_id"];
    [dict setObject:@"支付宝" forKey:@"account"];
    [dict setObject:@(3) forKey:@"account_id"];
    [dict setObject:@([Helper getRandomNumber:150 to:400]) forKey:@"amount"];
    [dict setObject:@(0) forKey:@"type"];
    [array addObject:dict];
}

#pragma mark - AccountM
/** 添加账户类型*/
- (void)addAccountM:(AccountM *)accountM{
    [_db jq_inDatabase:^{
        [_db jq_insertTable:@"t_account" dicOrModel:accountM];
    }];
}
/** 删除账户类型*/
- (void)deleteAccountM:(AccountM *)accountM{
    [_db jq_inDatabase:^{
        [_db jq_deleteTable:@"t_account" whereFormat:[NSString stringWithFormat:@"where pkid = %ld",accountM.pkid]];
    }];
}
/** 更新账户类型*/
- (void)updateAccountM:(AccountM *)accountM{
    [_db jq_inDatabase:^{
        [_db jq_updateTable:@"t_account" dicOrModel:accountM whereFormat:[NSString stringWithFormat:@"where pkid = %ld",accountM.pkid]];
    }];
}
/** 获取所有账户类型*/
- (NSArray *)getAllAccountM{
    NSArray *array = [_db jq_lookupTable:@"t_account" dicOrModel:[AccountM class] whereFormat:@""];
    
    return array;
}

#pragma mark - 支出分类
/** 添加支出分类*/
- (void)addClassM:(ClassM *)classM{
    [_db jq_inDatabase:^{
        [_db jq_insertTable:@"t_class" dicOrModel:classM];
    }];
}
/** 删除支出分类*/
- (void)deleteClassM:(ClassM *)classM{
    [_db jq_inDatabase:^{
        [_db jq_deleteTable:@"t_class" whereFormat:[NSString stringWithFormat:@"where class_id like '%ld%%%%'",classM.class_id]];
    }];
}
/** 更新支出分类*/
- (void)updateClassM:(ClassM *)classM{
    [_db jq_inDatabase:^{
        [_db jq_updateTable:@"t_class" dicOrModel:classM whereFormat:[NSString stringWithFormat:@"where pkid = %ld",classM.pkid]];
    }];
}
/** 获取所有支出分类*/
- (NSArray *)getClassMListWhere:(NSString *)where{
    NSArray *array = [_db jq_lookupTable:@"t_class" dicOrModel:[ClassM class] whereFormat:where];
    
    return array;
}

#pragma mark - 账单
/** 添加支出分类*/
- (void)addBillM:(BillM *)billM{
    [_db jq_inDatabase:^{
        [_db jq_insertTable:@"t_bill" dicOrModel:billM];
    }];
}
/** 删除支出分类*/
- (void)deleteBillM:(BillM *)billM{
    [_db jq_inDatabase:^{
        [_db jq_deleteTable:@"t_bill" whereFormat:[NSString stringWithFormat:@"where pkid like '%ld%%%%'",billM.pkid]];
    }];
}
/** 更新支出分类*/
- (void)updateBillM:(BillM *)billM{
    [_db jq_inDatabase:^{
        [_db jq_updateTable:@"t_bill" dicOrModel:billM whereFormat:[NSString stringWithFormat:@"where pkid = %ld",billM.pkid]];
    }];
}
/** 获取所有支出分类*/
- (NSArray *)getBillListWithBillS:(BillS *)billS{
    NSString *sql;
    if(billS){
        sql = [NSString stringWithFormat:@"where date(time,'unixepoch','localtime') >= '%@' and date(time,'unixepoch','localtime') <= '%@'",billS.start_time,billS.end_time];
    }
    NSArray *array = [_db jq_lookupTable:@"t_bill" dicOrModel:[BillM class] whereFormat:sql];
    
    return array;
}
/** 根据类型查询收入/支出总额*/
- (CGFloat)getAmountWithStart:(NSString *)start end:(NSString *)end type:(NSInteger)type{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"where type = '%ld'",type];
    if(start && end){
        [sql appendFormat:@" and date(time,'unixepoch','localtime') >= '%@' and date(time,'unixepoch','localtime') <= '%@'",start,end];
    }
    CGFloat amount = [_db jq_lookupTable:@"t_bill" sum:@"amount" whereFormat:sql];
    return amount;
}

@end
