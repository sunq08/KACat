//
//  SUExcelConfig.h
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const EXCellIdentifier;        // cell identifier
extern NSString *const EXHeaderIdentifier;      // head identifier
extern NSString *const EXCellInfoWidths;        // cell 传递信息 width集合
extern NSString *const EXCellInfoColumn;        // cell 传递信息 column数量
extern NSString *const EXCellInfoTitles;        // head 传递信息 title集合
extern NSString *const EXCellInfoNotif;         // cell 传递信息 notif
extern NSString *const EXCellInfoLock;          // cell 传递信息 左侧锁定
extern NSString *const EXCellCloseGrid;         // cell 传递信息 关闭网格效果
extern NSString *const EXCellInfoLockNumber;    // cell head 锁定列数

//以下参数基本上对于一个项目来说肯定是风格一致的，因此不需要使用代理方法给开发人员定义，直接使用宏就可以了
extern CGFloat   const EXCellMargin;            // cell label 水平间距
extern CGFloat   const EXCellHeight;            // cell 默认高度

//191 239 255
#define EXSimpleColor [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1]
#define EXBaseColor [UIColor colorWithRed:255./255. green:255./255. blue:255./255. alpha:1]
#define EXBackgroundColor [UIColor whiteColor]
#define EXBaseFont [UIFont systemFontOfSize:12]
@interface SUExcelConfig : NSObject

@end

@interface SUExcelLabel : UILabel

@end


NS_ASSUME_NONNULL_END
