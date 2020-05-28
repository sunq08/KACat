//
//  THCardView.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THCardView.h"
#import "THCardLabel.h"
#import "THKitConfig.h"
@interface THCardView()<THCardLabelDelegate>
@property (nonatomic, strong, readwrite) NSString      *selectValue;

@end
@implementation THCardView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)initUI{
    self.backgroundColor = [UIColor clearColor];
    self.singleNum = 4;
}

- (void)setPickerData:(NSArray<NSDictionary *> *)pickerData{
    if (_pickerData == pickerData) {
        return;
    }
    _pickerData = pickerData;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    NSMutableArray *selectData = [NSMutableArray arrayWithArray:pickerData];
    if(self.allbtn){
        [selectData insertObject:@{@"":@"全部"} atIndex:0];
    }
    THCardLabel *lastLabel;
    for (int i = 0; i < selectData.count; i ++) {
        NSDictionary *dict = [selectData objectAtIndex:i];
        NSString *value = [dict allValues][0];
        NSString *key = [dict allKeys][0];
        
        THCardLabelStyle style = (self.multiple)?THCardLabelCheckBox:THCardLabelRadio;
        THCardLabel *label = [THCardLabel creatLabelWith:style];
        if(i == 0) {
            self.selectValue = key;
            label.selected = YES;
        }
        label.text = value;
        label.val  = key;
        label.delegate = self;
        [self addSubview:label];
        
        float multiplier = 1.0/self.singleNum;
        if(i == 0){
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.equalTo(self);
                make.height.equalTo(@(30.0));
                make.width.equalTo(self.mas_width).multipliedBy(multiplier).offset(-6.0);
            }];
        }else{
            if(i%self.singleNum == 0){//每行第一个
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self);
                    make.top.equalTo(lastLabel.mas_bottom).offset(6.0);
                    make.height.equalTo(@(30.0));
                    make.width.equalTo(self.mas_width).multipliedBy(multiplier).offset(-6.0);
                }];
            }else{//中间的
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastLabel.mas_right).offset(6.0);
                    make.top.equalTo(lastLabel.mas_top);
                    make.height.equalTo(@(30.0));
                    make.width.equalTo(self.mas_width).multipliedBy(multiplier).offset(-6.0);
                }];
            }
        }
        lastLabel = label;
    }
}

- (void)setDefaultValue:(NSString *)defaultValue{
    if (![_defaultValue isEqualToString:defaultValue]) {
        _defaultValue = defaultValue;
        for (THCardLabel *label in self.subviews) {
            if([label isKindOfClass:[THCardLabel class]]){
                if([label.val isEqualToString:defaultValue]){
                    self.selectValue = defaultValue;
                    label.selected = YES;
                }else{
                    label.selected = NO;
                }
            }
        }
    }
}

- (void)thCardLabelTouchUpInside:(THCardLabel *)sender{
    if(sender.selected){
        self.selectValue = sender.val;
    }else self.selectValue = @"";
    
    if(self.valueChanged){
        self.valueChanged(self.selectValue);
    }
}

- (void)resetValue{
    self.selectValue = @"";
    for (THCardLabel *label in self.subviews) {
        if([label isKindOfClass:[THCardLabel class]]){
            label.selected = NO;
        }
    }
}

- (CGFloat)getCardViewHeightWithSupW:(CGFloat)width{
    float height = 0.0;
    NSInteger count = (self.pickerData)?self.pickerData.count+1:1;
    NSInteger row = count/self.singleNum;
    height += (row*36);
    return height;
}

@end
