//
//  UITableView+Category.m
//  EasyAccount
//
//  Created by SunQ on 2019/5/15.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "UITableView+Category.h"

@implementation UITableView (Category)

/**  删除多余的cell、 分割线*/
-(void)deleteExtraCellLine{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [view removeFromSuperview];
}

@end
