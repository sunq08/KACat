//
//  UITextFieldPicker.m
//  itonghui_BulkSpot
//
//  Created by 任芳 on 2017/4/18.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import "UITextFieldPicker.h"

@interface UITextFieldPicker()<UIPickerViewDelegate, UIPickerViewDataSource> {
    UIPickerView *pickerView;
}

@end

@implementation UITextFieldPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self initBase];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initBase];
    return self;
}

- (void)initBase{
    self.tintColor =[UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!pickerView) {
        pickerView = [[UIPickerView alloc] init];
        [pickerView setBackgroundColor:[UIColor whiteColor]];
        pickerView.dataSource = self;
        pickerView.delegate = self;
        self.inputView = pickerView;
    }
}

- (BOOL)becomeFirstResponder{
    BOOL become = [super becomeFirstResponder];
    if(!self.val || [self.val isEqualToString:@""]){
        if([self.pickerData isKindOfClass:[NSDictionary class]] && [self.pickerData allKeys].count != 0){
            NSArray *dataKey = [self.pickerData allKeys];
            self.val = dataKey[0];
        }
    } else {
        if([self.pickerData isKindOfClass:[NSDictionary class]] && [self.pickerData allKeys].count != 0){
            int index = 0;
            NSArray *dataKey = [self.pickerData allKeys];
            for (int i = 0 ; i < dataKey.count ; i ++) {
                NSString *data = dataKey[i];
                if([data isEqualToString:self.val]){
                    index = i;
                    break;
                }
            }
            [pickerView selectRow:index inComponent:0 animated:NO];
        }
    }
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    return resign;
}

- (void)setVal:(NSString *)val{
    _val = val;
    
    if([val isEqualToString:@""]){
        self.text = @"";
        [pickerView selectRow:0 inComponent:0 animated:NO];
    } else {
        self.text = [self.pickerData objectForKey:val];
    }
}

- (void)reset{
    self.text = @"";
    [pickerView selectRow:0 inComponent:0 animated:NO];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

// 几列数据
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return [UIScreen mainScreen].bounds.size.width;
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *dataKey = [self.pickerData allKeys];
    self.val = dataKey[row];
}

// 显示每行每列的数据
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *dateValue = [self.pickerData allValues];
    return dateValue[row];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:))//禁止粘贴
        return NO;
    if (action == @selector(select:))// 禁止选择
        return NO;
    if (action == @selector(selectAll:))// 禁止全选
        return NO;
    return [super canPerformAction:action withSender:sender];
}

@end

