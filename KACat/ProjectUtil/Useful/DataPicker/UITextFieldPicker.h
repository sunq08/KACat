//
//  UITextFieldPicker.h
//  itonghui_BulkSpot
//
//  Created by 任芳 on 2017/4/18.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextFieldPicker : UITextField

//数据源
@property (nonatomic, strong)NSDictionary *pickerData;

//取值
@property (nonatomic, strong) NSString *val;

//重置
- (void)reset;

@end

