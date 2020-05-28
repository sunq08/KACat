//
//  THScreenBaseCell.h
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class THScreenBaseM;
@interface THScreenBaseCell : UITableViewCell
+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView;
- (void)setupUI;
- (void)setupDataModel:(THScreenBaseM *)model;

@property (nonatomic,   copy) NSString *identifier;
@property (nonatomic, assign) NSInteger cellIndex;

@end

NS_ASSUME_NONNULL_END
