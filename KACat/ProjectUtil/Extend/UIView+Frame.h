//
//  UIView+Frame.h
//  YJTabBarPer
//
//  Created by houdage on 15/11/17.
//  Copyright © 2015年 YJHou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;

/**配置圆角 */
-(void)layoutRadius:(CGFloat)cornerRadius;
/**给哪几个角设置圆角 */
-(void)layoutRadius:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;
/**配置圆角边框 */
-(void)layoutBorderRadius:(CGFloat)cornerRadius color:(UIColor *)color width:(CGFloat)width;
/**设置阴影 */
-(void)layoutShadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

/**获取controller*/
- (UIViewController *)viewController;
/**加载xib 创建的 View*/
+ (instancetype)viewFromXib;
@end
