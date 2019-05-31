//
//  SQCardView.h
//  EasyAccount
//
//  Created by SunQ on 2018/9/28.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SQCardViewDataSource <NSObject>

@end

@interface SQCardView : UIView

@property (nonatomic,  weak) id<SQCardViewDataSource> dataSource;

- (void)addDataWithList:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
