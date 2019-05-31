//
//  UIView+Frame.m
//  YJTabBarPer
//
//  Created by houdage on 15/11/17.
//  Copyright © 2015年 YJHou. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
    
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}
    
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

/**配置圆角 */
-(void)layoutRadius:(CGFloat)radius{
    [self.layer setCornerRadius:radius];
    [self.layer setMasksToBounds:YES];
}

/**配置圆角边框 */
-(void)layoutBorderRadius:(CGFloat)radius color:(UIColor *)color width:(CGFloat)width{
    [self.layer setCornerRadius:radius];
    [self.layer setBorderWidth:width];;
    [self.layer setBorderColor:[color CGColor]];
    [self.layer setMasksToBounds:YES];
}

+ (instancetype)viewFromXib
{
    NSString *className = NSStringFromClass([self class]);
    id object = [[[NSBundle mainBundle]loadNibNamed:className owner:nil options:nil]lastObject];
    if ([object isKindOfClass:[self class]]) {
        return object;
    }
    return  nil;
}

@end
