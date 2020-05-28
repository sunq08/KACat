//
//  THCardLabel.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

//card label
#define THCardSeletedColor   thrgb(122.0,174.0,235.0)//头部的颜色

#import "THCardLabel.h"
#import "THKitConfig.h"
@interface THCardLabel()
@property (nonatomic ,assign) THCardLabelStyle style;
@end
@implementation THCardLabel

+ (instancetype)creatLabelWith:(THCardLabelStyle)style{
    THCardLabel *label = [THCardLabel buttonWithType:UIButtonTypeCustom];
    label.style = style;
    [label.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [label setTitleColor:THCardSeletedColor forState:UIControlStateNormal];
    [label setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [label setBackgroundImage:[THKitConfig imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [label setBackgroundImage:[THKitConfig imageWithColor:THCardSeletedColor] forState:UIControlStateSelected];
    [THKitConfig layoutViewRadioWith:label radio:3 color:THCardSeletedColor];
    [THKitConfig layoutViewRadioWith:label radio:2];
    [label addTarget:label action:@selector(cardClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return label;
}

- (void)cardClick:(THCardLabel *)sender{
    if(self.style == THCardLabelRadio){//单选
        if(sender.selected){//取消选择
            sender.selected = NO;
            if([self.delegate respondsToSelector:@selector(thCardLabelTouchUpInside:)]){
                [self.delegate thCardLabelTouchUpInside:self];
            }
        }else{//选择其他
            UIView *supView = [sender superview];
            NSArray *subViews = [supView subviews];
            for (THCardLabel *label in subViews) {
                if([label isKindOfClass:[THCardLabel class]]) label.selected = NO;
            }
            sender.selected = YES;
            if([self.delegate respondsToSelector:@selector(thCardLabelTouchUpInside:)]){
                [self.delegate thCardLabelTouchUpInside:self];
            }
        }
    }else{//多选
        sender.selected = !sender.selected;
        if([self.delegate respondsToSelector:@selector(thCardLabelTouchUpInside:)]){
            [self.delegate thCardLabelTouchUpInside:self];
        }
    }
}

- (void)setText:(NSString *)text{
    _text = text;
    [self setTitle:text forState:UIControlStateNormal];
}


@end
