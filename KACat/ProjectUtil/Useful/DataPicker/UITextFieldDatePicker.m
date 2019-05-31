//
//  UITextFieldDatePicker.m
//  itonghui_BulkSpot
//
//  Created by 任芳 on 2017/4/18.
//  Copyright © 2017年 itonghui. All rights reserved.
//

#import "UITextFieldDatePicker.h"

@interface UITextFieldDatePicker(){
    UIDatePicker *datePicker;
}

@end

@implementation UITextFieldDatePicker

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!datePicker) {
        // 时间选择器
        datePicker = [[UIDatePicker alloc] init];
        [datePicker setBackgroundColor:[UIColor whiteColor]];
        if(self.datePickerMode != UIDatePickerModeDate){
            datePicker.datePickerMode = self.datePickerMode;
        }
        self.inputView = datePicker;
        // 默认值
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        [format setDateFormat:@"yyyy-MM-dd"];
//        [datePicker setDate:[NSDate date]];
//        self.text = [format stringFromDate:datePicker.date];
    }
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.text = [format stringFromDate:datePicker.date];
    
    return resign;
}

@end
