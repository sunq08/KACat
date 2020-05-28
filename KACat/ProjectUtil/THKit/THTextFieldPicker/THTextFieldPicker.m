//
//  THTextFieldPicker.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THTextFieldPicker.h"
static NSString  * const formatD = @"yyyy-MM-dd HH:mm:ss";
//text filed
#define THToolbarTintColor  [UIColor darkGrayColor]//toolbar按钮颜色

@interface THTextFieldPicker()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic ,assign) THTextFiledPickerStyle style;      //0,下拉菜单。1，侧滑菜单
@end
@implementation THTextFieldPicker

+ (instancetype)creatTextFiledWithStyle:(THTextFiledPickerStyle)style{
    THTextFieldPicker *textFiled = [[THTextFieldPicker alloc]initWithFrame:CGRectZero style:style];
    return textFiled;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBase];
}
- (id)initWithFrame:(CGRect)frame style:(THTextFiledPickerStyle)style{
    self = [super initWithFrame:frame];
    if (self){
        self.style = style;
        [self initBase];
    }
    return self;
}

- (void)initBase{
    self.tintColor =[UIColor clearColor];
    if(self.style == THTextFiledTimePicker){
        self.inputView = self.datePicker;
    }else{
        self.inputView = self.pickerView;
    }
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    toolbar.tintColor = [UIColor blueColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton    * customBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 44)];
    [customBtn1 setTitle:@"清除" forState:UIControlStateNormal];
    [customBtn1 setTitleColor:THToolbarTintColor forState:UIControlStateNormal];
    customBtn1.enabled = NO;
    [customBtn1 addTarget:self action:@selector(clearDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * clear = [[UIBarButtonItem alloc] initWithCustomView:customBtn1];
    
    UIButton    * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 44)];
    [customBtn setTitle:@"完成" forState:UIControlStateNormal];
    [customBtn setTitleColor:THToolbarTintColor forState:UIControlStateNormal];
    customBtn.enabled = NO;
    [customBtn addTarget:self action:@selector(selectDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * down = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    toolbar.items = @[clear, space, down];
    self.inputAccessoryView = toolbar;
}

#pragma mark - super getting
- (UIPickerView *)pickerView{
    if(!_pickerView){
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setBackgroundColor:[UIColor whiteColor]];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (UIDatePicker *)datePicker{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc] init];
        [_datePicker setBackgroundColor:[UIColor whiteColor]];
        _datePicker.datePickerMode = UIDatePickerModeDate;
    }
    return _datePicker;
}

#pragma mark - super setting
- (void)setVal:(NSString *)val{
    _val = val;
    
    if(self.style == THTextFiledCommonPicker){
        if([val isEqualToString:@""]){
            self.text = @"";
            [_pickerView selectRow:0 inComponent:0 animated:NO];
        } else {
            for (NSDictionary *dic in self.pickerData) {
                if ([dic objectForKey:val]) {
                    self.text = [dic objectForKey:val];
                    break;
                }
            }
        }
    }else{
        self.text = val;
        if(![val isEqualToString:@""]){
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:_dateFormate?_dateFormate: formatD];
            _datePicker.date = [format dateFromString:val];
        }
    }
}

- (void)setStyle:(THTextFiledPickerStyle)style{
    _style = style;
}

#pragma mark - super function
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (BOOL)becomeFirstResponder{
    BOOL become = [super becomeFirstResponder];
    return become;
}

- (BOOL)resignFirstResponder {
    BOOL resign = [super resignFirstResponder];
    return resign;
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

// 显示每行每列的数据
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row].allValues[0];
}

#pragma mark - private function
- (void)clearDone{
    self.val = @"";
    [self resignFirstResponder];
}

- (void)selectDone{
    if(self.style == THTextFiledTimePicker){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:_dateFormate?_dateFormate: formatD];
        self.val = [format stringFromDate:_datePicker.date];
    }else{
        if(self.pickerData && self.pickerData.count != 0){
            NSInteger row = [self.pickerView selectedRowInComponent:0];
            self.val = self.pickerData[row].allKeys[0];
        }
    }
    [self resignFirstResponder];
}

@end
