//
//  UIButton+Category.m
//  DIMI
//
//  Created by SunQ on 2018/5/18.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>
@implementation UIButton (Category)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}

- (void)setTitleNormal:(NSString *)titleNormal{
    [self setTitle:titleNormal forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(titleNormal), titleNormal, OBJC_ASSOCIATION_RETAIN);
}

- (NSString * )titleNormal{
    NSString *string = objc_getAssociatedObject(self, @selector(titleNormal));
    return string;
}

- (void)setTitleSelected:(NSString *)titleSelected{
    [self setTitle:titleSelected forState:UIControlStateSelected];
    objc_setAssociatedObject(self, @selector(titleSelected), titleSelected, OBJC_ASSOCIATION_RETAIN);
}

- (NSString * )titleSelected{
    NSString *string = objc_getAssociatedObject(self, @selector(titleSelected));
    return string;
}

- (void)setImageNormal:(UIImage *)imageNormal{
    [self setImage:imageNormal forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(imageNormal), imageNormal, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)imageNormal{
    UIImage *image = objc_getAssociatedObject(self, @selector(imageNormal));
    return image;
}

- (void)setImageSelected:(UIImage *)imageSelected{
    [self setImage:imageSelected forState:UIControlStateSelected];
    objc_setAssociatedObject(self, @selector(imageSelected), imageSelected, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)imageSelected{
    UIImage *image = objc_getAssociatedObject(self, @selector(imageSelected));
    return image;
}


- (void)setTitleColorNormal:(UIColor *)titleColorNormal{
    [self setTitleColor:titleColorNormal forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(titleColorNormal), titleColorNormal, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)titleColorNormal{
    UIColor *color = objc_getAssociatedObject(self, @selector(titleColorNormal));
    return color;
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected{
    [self setTitleColor:titleColorSelected forState:UIControlStateSelected];
    objc_setAssociatedObject(self, @selector(titleColorSelected), titleColorSelected, OBJC_ASSOCIATION_RETAIN);
}

- (UIColor *)titleColorSelected{
    UIColor *color = objc_getAssociatedObject(self, @selector(titleColorSelected));
    return color;
}

- (void)setTitleFont:(UIFont *)titleFont{
    self.titleLabel.font = titleFont;
    objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN);
}

- (UIFont *)titleFont{
    UIFont *font = objc_getAssociatedObject(self, @selector(titleFont));
    return font;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/// 图片与标题显示样式
- (void)buttonStyle:(THButtonStyle)style offSet:(CGFloat)offset{
    CGFloat imageWidth = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CGFloat labelWidth = [self.titleLabel.text sizeWithFont:self.titleLabel.font].width;
    CGFloat labelHeight = [self.titleLabel.text sizeWithFont:self.titleLabel.font].height;
#pragma clang diagnostic pop
    
    // image中心移动的x距离
    CGFloat imageOringinX = (imageWidth + labelWidth) / 2 - imageWidth / 2;
    // image中心移动的y距离
    CGFloat imageOriginY = imageHeight / 2 + offset / 2;
    // label中心移动的x距离
    CGFloat labelOriginX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;
    // label中心移动的y距离
    CGFloat labelOriginY = labelHeight / 2 + offset / 2;
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + offset - tempHeight;
    switch (style) {
        case THButtonStyleImageLeft:
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, (-offset / 2), 0.0, (offset / 2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, (offset / 2), 0.0, (-offset / 2));
            self.contentEdgeInsets = UIEdgeInsetsMake(0.0, (offset / 2), 0.0, (offset / 2));
            break;
        case THButtonStyleImageRight:
            self.imageEdgeInsets = UIEdgeInsetsMake(0.0, (labelWidth + offset / 2), 0.0, -(labelWidth + offset / 2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -(imageWidth + offset / 2), 0.0, (imageWidth + offset / 2));
            self.contentEdgeInsets = UIEdgeInsetsMake(0.0, offset / 2, 0.0, offset / 2);
            break;

        case SYButtonStyleImageTop:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOriginY, imageOringinX, imageOriginY, -imageOringinX);
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOriginY, -labelOriginX, -labelOriginY, labelOriginX);
            self.contentEdgeInsets = UIEdgeInsetsMake(imageOriginY, (-changedWidth / 2), (changedHeight - imageOriginY), (-changedWidth / 2));
            break;
        case SYButtonStyleImageBottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOriginY, imageOringinX, -imageOriginY, -imageOringinX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOriginY, -labelOriginX, labelOriginY, labelOriginX);
            self.contentEdgeInsets = UIEdgeInsetsMake((changedHeight - imageOriginY), (-changedWidth / 2), imageOriginY, (-changedWidth / 2));
            break;
        default:
            break;
    }
}

#pragma mark -  倒计时按钮 返回重置时间
- (void)startWithTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle{
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@%@",timeStr,subTitle] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

@end
