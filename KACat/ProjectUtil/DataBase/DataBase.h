//
//  DataBase.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/10.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountM;
@class ClassM;
@class BillM;

@class BillS;
@interface DataBase : NSObject

+ (instancetype)sharedDataBase;
/**清空数据*/
- (void)deleteDataBase;

#pragma mark - 账户
/** 添加账户类型*/
- (void)addAccountM:(AccountM *)accountM;
/** 删除账户类型*/
- (void)deleteAccountM:(AccountM *)accountM;
/** 更新账户类型*/
- (void)updateAccountM:(AccountM *)accountM;
/** 获取所有账户类型*/
- (NSArray *)getAllAccountM;

#pragma mark - 分类
/** 添加分类*/
- (void)addClassM:(ClassM *)classM;
/** 删除分类*/
- (void)deleteClassM:(ClassM *)classM;
/** 更新分类*/
- (void)updateClassM:(ClassM *)classM;
/** 获取所有分类*/
- (NSArray *)getClassMListWhere:(NSString *)where;

#pragma mark - 账单
/** 添加支出分类*/
- (void)addBillM:(BillM *)billM;
/** 删除支出分类*/
- (void)deleteBillM:(BillM *)billM;
/** 更新支出分类*/
- (void)updateBillM:(BillM *)billM;
/** 获取所有支出分类*/
- (NSArray *)getBillListWithBillS:(BillS *)billS;
/** 根据类型查询收入/支出总额*/
- (CGFloat)getAmountWithStart:(NSString *)start end:(NSString *)end type:(NSInteger)type;

@end
