//
//  SUExcelHeader.h
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUExcelHeader : UITableViewHeaderFooterView
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier notificationID:(NSString *)notificationID;

/** 独立设置，非初始化设置，是因为设置excel代理之前，head就会初始化*/
@property (nonatomic, strong) NSMutableDictionary    *cellInfo;

@end

NS_ASSUME_NONNULL_END
