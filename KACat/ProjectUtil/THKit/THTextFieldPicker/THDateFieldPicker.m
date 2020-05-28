//
//  THDateFieldPicker.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDateFieldPicker.h"
@interface THDateFieldPicker()<UIPickerViewDelegate, UIPickerViewDataSource>{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
}
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@end
@implementation THDateFieldPicker

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initBase];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initBase];
    }
    return self;
}

- (void)initBase{
    self.tintColor =[UIColor clearColor];
    self.inputView = self.pickerView;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    toolbar.tintColor = [UIColor blueColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton    * customBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 44)];
    [customBtn1 setTitle:@"清除" forState:UIControlStateNormal];
    [customBtn1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    customBtn1.enabled = NO;
    [customBtn1 addTarget:self action:@selector(clearDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * clear = [[UIBarButtonItem alloc] initWithCustomView:customBtn1];
    
    UIButton    * customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 60, 44)];
    [customBtn setTitle:@"完成" forState:UIControlStateNormal];
    [customBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    customBtn.enabled = NO;
    [customBtn addTarget:self action:@selector(selectDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * down = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    
    toolbar.items = @[clear, space, down];
    self.inputAccessoryView = toolbar;
    
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year=[comps year];
    
    startYear = year - 100;
    yearRange = 200;
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

#pragma mark - super function
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (BOOL)becomeFirstResponder{
    BOOL become = [super becomeFirstResponder];
    [self setCurrentDate:[NSDate date]];
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

#pragma mark - private function
- (void)clearDone{
    self.text = @"";
    [self resignFirstResponder];
}

- (void)selectDone{
    //do something
    self.text = _string;
    [self resignFirstResponder];
}

//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate {
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    NSInteger second=[comps second];
    
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedHour = hour;
    selectedMinute = minute;
    selectedSecond = second;
    
    dayRange = [self isAllDay:year andMonth:month];
    
    if (self.pickerViewMode == THDateFiledSecondMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        
        [self.pickerView selectRow:second inComponent:5 animated:NO];
        [self pickerView:self.pickerView didSelectRow:second inComponent:5];
    } else if (self.pickerViewMode == THDateFiledMinuteMode) {
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        
        [self.pickerView selectRow:minute inComponent:4 animated:NO];
        [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
    } else if (self.pickerViewMode == THDateFiledHourMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        
        [self.pickerView selectRow:hour inComponent:3 animated:NO];
        [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
    } else if (self.pickerViewMode == THDateFiledDayMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        
        [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
        [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    } else if (self.pickerViewMode == THDateFiledMonthMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
        
        [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
        [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
    } else if (self.pickerViewMode == THDateFiledYearMode){
        [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
        [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
    }
    //    [self.pickerView reloadAllComponents];
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickerViewMode == THDateFiledSecondMode){
        return 6;
    }else if (self.pickerViewMode == THDateFiledMinuteMode) {
        return 5;
    }else if (self.pickerViewMode == THDateFiledHourMode){
        return 4;
    }else if (self.pickerViewMode == THDateFiledDayMode){
        return 3;
    }else if (self.pickerViewMode == THDateFiledMonthMode){
        return 2;
    }else if (self.pickerViewMode == THDateFiledYearMode){
        return 1;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.pickerViewMode == THDateFiledSecondMode){
        switch (component) {
            case 0: return yearRange; break;
            case 1: return 12; break;
            case 2: return dayRange; break;
            case 3: return 24; break;
            case 4: return 60; break;
            case 5: return 60; break;
            default: break;
        }
    } else if (self.pickerViewMode == THDateFiledMinuteMode) {
        switch (component) {
            case 0:return yearRange;break;
            case 1:return 12;break;
            case 2:return dayRange;break;
            case 3:return 24;break;
            case 4:return 60;break;
            default: break;
        }
    } else if (self.pickerViewMode == THDateFiledHourMode){
        switch (component) {
            case 0: return yearRange; break;
            case 1: return 12; break;
            case 2: return dayRange; break;
            case 3: return 24; break;
            default: break;
        }
    } else if (self.pickerViewMode == THDateFiledDayMode){
        switch (component) {
            case 0: return yearRange; break;
            case 1: return 12; break;
            case 2: return dayRange; break;
            default: break;
        }
    } else if (self.pickerViewMode == THDateFiledMonthMode){
        switch (component) {
            case 0: return yearRange; break;
            case 1: return 12; break;
            default: break;
        }
    } else if (self.pickerViewMode == THDateFiledYearMode){
        switch (component) {
            case 0: return yearRange; break;
            default: break;
        }
    }
    return 0;
}


#pragma mark -- UIPickerViewDelegate
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel*label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:15.0];
    label.textAlignment=NSTextAlignmentCenter;
    
    if (self.pickerViewMode == THDateFiledSecondMode) {
        switch (component) {
            case 0:
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                break;
            case 1:
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                break;
            case 2:
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
                break;
            case 3:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                break;
            case 4:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                break;
            case 5:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
                break;
            default:
                break;
        }
    }else if (self.pickerViewMode == THDateFiledMinuteMode){
        switch (component) {
            case 0:
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                break;
            case 1:
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                break;
            case 2:
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
                break;
            case 3:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                break;
            case 4:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == THDateFiledHourMode){
        switch (component) {
            case 0:
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                break;
            case 1:
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                break;
            case 2:
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
                break;
            case 3:
                label.textAlignment=NSTextAlignmentRight;
                label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == THDateFiledDayMode){
        switch (component) {
            case 0:
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                break;
            case 1:
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                break;
            case 2:
                label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == THDateFiledMonthMode){
        switch (component) {
            case 0:
                label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                break;
            case 1:
                label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                break;
            default:
                break;
        }
    } else if (self.pickerViewMode == THDateFiledYearMode){
        label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
    }
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewMode == THDateFiledSecondMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/6;
    } else if (self.pickerViewMode == THDateFiledMinuteMode) {
        return ([UIScreen mainScreen].bounds.size.width-40)/5;
    } else if (self.pickerViewMode == THDateFiledHourMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/4;
    } else if (self.pickerViewMode == THDateFiledDayMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/3;
    } else if (self.pickerViewMode == THDateFiledMonthMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/2;
    } else if (self.pickerViewMode == THDateFiledYearMode){
        return ([UIScreen mainScreen].bounds.size.width-40)/1;
    }
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerViewMode == THDateFiledSecondMode){
        switch (component) {
            case 0: {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2: selectedDay=row+1; break;
            case 3: selectedHour=row; break;
            case 4: selectedMinute=row; break;
            case 5: selectedSecond=row; break;
            default: break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute,selectedSecond];
    } else if (self.pickerViewMode == THDateFiledMinuteMode) {
        switch (component) {
            case 0:{
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:selectedDay=row+1;break;
            case 3:selectedHour=row;break;
            case 4:selectedMinute=row;break;
            default: break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
    }else if (self.pickerViewMode == THDateFiledHourMode){
        switch (component) {
            case 0: {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2: selectedDay=row+1; break;
            case 3: selectedHour=row; break;
                
            default: break;
        }
        
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld",selectedYear,selectedMonth,selectedDay,selectedHour];
    } else if (self.pickerViewMode == THDateFiledDayMode){
        switch (component) {
            case 0: {
                selectedYear=startYear + row;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1: {
                selectedMonth=row+1;
                dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:selectedDay=row+1;break;
            default:
                break;
        }
        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",selectedYear,selectedMonth,selectedDay];
    } else if (self.pickerViewMode == THDateFiledMonthMode){
        switch (component) {
            case 0: selectedYear = startYear + row;break;
            case 1: selectedMonth = row+1; break;
            default: break;
        }
        _string = [NSString stringWithFormat:@"%ld-%.2ld",selectedYear,selectedMonth];
    } else if (self.pickerViewMode == THDateFiledYearMode){
        switch (component) {
            case 0 : selectedYear = startYear + row;break;
            default: break;
        }
        _string =[NSString stringWithFormat:@"%ld",selectedYear];
    }
}


#pragma mark - 选择对应月份的天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month{
    if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12){
        return 31;
    }else if (month == 4 || month == 6 || month == 9 || month == 11){
        return 30;
    }else if (month == 2){
        if(((year%4 == 0) && (year%100 != 0)) || (year%400 == 0)){
            return 29;
        } else {
            return 28;
        }
    }
    return 0;
}
@end
