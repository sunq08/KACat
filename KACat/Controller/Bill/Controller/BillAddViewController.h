//
//  BillAddViewController.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BillAddReturnBlock) (void);

@class BillM;
@interface BillAddViewController : UIViewController

@property (nonatomic,strong) BillM *billM;

//返回刷新
@property (nonatomic,   copy) BillAddReturnBlock   refreshBlock;

@end
