//
//  THDataImageCell.h
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class THDataM;
@interface THDataImageCell : UITableViewCell
- (void)configCellModel:(THDataM *)model;
@end

NS_ASSUME_NONNULL_END
