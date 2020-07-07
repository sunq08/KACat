//
//  SUExcelConfig.m
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "SUExcelConfig.h"
NSString *const EXCellIdentifier     = @"SUExcelCell";            // cell identifier
NSString *const EXHeaderIdentifier   = @"SUExcelHeader";          // head identifier
NSString *const EXCellInfoWidths     = @"EXCellInfoWidths";       // cell 传递信息 width集合
NSString *const EXCellInfoColumn     = @"EXCellInfoColumn";       // cell 传递信息 column数量
NSString *const EXCellInfoTitles     = @"EXCellInfoTitles";       // head 传递信息 title集合
NSString *const EXCellInfoNotif      = @"EXCellInfoNotif";        // cell 传递信息 notif
NSString *const EXCellIndexPath      = @"EXCellIndexPath";        // cell 传递信息 notif
NSString *const EXCellInfoLock       = @"EXCellInfoLock";         // cell 传递信息 左侧锁定
NSString *const EXCellCloseGrid      = @"EXCellCloseGrid";        // cell 传递信息 关闭网格效果
NSString *const EXCellInfoLockNumber = @"EXCellInfoLockNumber";   // cell head 锁定列数


//以下参数基本上对于一个项目来说肯定是风格一致的，因此不需要使用代理方法给开发人员定义，直接使用宏就可以了
CGFloat   const EXCellMargin        = 4.0;                  // cell label 水平间距
CGFloat   const EXCellHeight        = 40.0;
@implementation SUExcelConfig

@end

@implementation SUExcelLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, EXCellMargin, 0, EXCellMargin};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end

