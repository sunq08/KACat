//
//  SelectClassViewController.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/16.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnBlock) (NSInteger class_id, NSString *class_name);

@interface SelectClassViewController : UIViewController
//返回刷新
@property (nonatomic,   copy) ReturnBlock   refreshBlock;
//类型，0支出，1收入
@property (nonatomic, assign) NSInteger     type;

@end
