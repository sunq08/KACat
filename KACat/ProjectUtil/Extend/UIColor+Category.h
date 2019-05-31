//
//  UIColor+Category.h
//  iOS-Category
//
//  Created by 庄BB的MacBook on 2017/8/23.
//  Copyright © 2017年 BBFC. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 功能:通过RGB创建颜色 rgb(173.0,23.0,11.0)*/
UIColor *rgb(CGFloat red, CGFloat green, CGFloat blue);

/** 功能:通过RGB以及alpha创建颜色 rgbA(173.0,23.0,11.0,0.5) */
UIColor *rgbA(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha);

@interface UIColor (Category)

/** Create a color from a HEX string. */
+ (UIColor *)hex:(NSString *)hexString;

/** 通过0xffffff的16进制数字创建颜色 */
+ (UIColor *)colorWithRGB:(NSUInteger)aRGB;

/** 调节颜色的明亮度  */
+ (UIColor*) colorRGBonvertToHSB:(UIColor*)color withBrighnessDelta:(CGFloat)delta;

/** 调整颜色的透明度 */
+ (UIColor*) colorRGBonvertToHSB:(UIColor*)color withAlphaDelta:(CGFloat)delta;

/** 随机色 */
+ (instancetype)UI_RandomColor;


@end
