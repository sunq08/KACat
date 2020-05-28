//
//  ThCommonCell.h
//  QIAQIA
//
//  Created by 孙强 on 2020/4/3.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol THCommonCellDelegate <NSObject>
- (void)commonCellButtonClickWithIdentifier:(NSString *)identifier index:(NSInteger)index;
@end

@class THCommonConfigM;
@class THDataConfigM;
@interface ThCommonCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier configM:(THCommonConfigM *)configM;
@property (nonatomic, assign) id<THCommonCellDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) THDataConfigM *dataM;
@end

NS_ASSUME_NONNULL_END
