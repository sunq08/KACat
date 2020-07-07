//
//  SUExcelCell.h
//  GHKC
//
//  Created by SunQ on 2019/8/15.
//  Copyright © 2019年 Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUExcelCell : UITableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellInfo:(NSMutableDictionary *)cellInfo;

@property (nonatomic, strong) NSIndexPath       *indexPath; //索引

@property (nonatomic,   copy) void (^excelCellClick)(NSIndexPath *indexPath);

- (UILabel *)configLabelWithColumn:(NSInteger)column;
@end

NS_ASSUME_NONNULL_END
