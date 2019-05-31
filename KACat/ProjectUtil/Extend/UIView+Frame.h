//
//  UIView+Frame.h
//  YJTabBarPer
//
//  Created by houdage on 15/11/17.
//  Copyright © 2015年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**控件左上角 x 坐标*/
@property (nonatomic, assign) CGFloat x;
/**控件左上角 y 坐标*/
@property (nonatomic, assign) CGFloat y;
/**控件的中心点 x 坐标*/
@property (nonatomic, assign) CGFloat centerX;
/**控件的中心点 y 坐标*/
@property (nonatomic, assign) CGFloat centerY;
/**控件的宽度*/
@property (nonatomic, assign) CGFloat width;
/**控件高度*/
@property (nonatomic, assign) CGFloat height;
/**控件底部*/
@property (nonatomic) CGFloat bottom;

/**配置圆角 */
-(void)layoutRadius:(CGFloat)radius;
/**配置圆角边框 */
-(void)layoutBorderRadius:(CGFloat)radius color:(UIColor *)color width:(CGFloat)width;

/**加载xib 创建的 View*/
+ (instancetype)viewFromXib;
@end
