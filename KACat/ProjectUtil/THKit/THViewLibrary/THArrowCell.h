//
//  THArrowCell.h
//  GYSA
//
//  Created by SunQ on 2019/11/5.
//  Copyright © 2019 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class THArrowCell;
///<点击事件
typedef void(^THCellClick)(THArrowCell *cell);

@interface THArrowCell : UIView
/** 快捷创建arrowCell*/
+ (instancetype)arrowCell;
/**图标*/
@property (nonatomic, strong) IBInspectable UIImage   *mainImg;
/**标题*/
@property (nonatomic, strong) IBInspectable NSString  *title;
/**详细标题*/
@property (nonatomic, strong) IBInspectable NSString  *detailTitle;
/**是否隐藏箭头 默认为NO*/
@property (nonatomic, assign) IBInspectable BOOL      hideArrow;
/**是否隐藏下边线 默认为NO*/
@property (nonatomic, assign) IBInspectable BOOL      hideLine;
/**下边线是否顶头 默认为NO*/
@property (nonatomic, assign) IBInspectable BOOL      lineToLeft;
/**给cell 添加点击事件*/
@property (nonatomic,   copy) THCellClick actionBlock;///<cell点击事件
@end

NS_ASSUME_NONNULL_END
