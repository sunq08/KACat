//
//  THScreenDateCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenDateCell.h"
#import "THTextFieldPicker.h"
#import "THDateFieldPicker.h"
#import "THScreenDateM.h"
#import "THKitConfig.h"
@interface THScreenDateCell()
@property (nonatomic ,strong) THTextFieldPicker     *typePicker;
@property (nonatomic ,strong) THDateFieldPicker     *datePicker;
@property (nonatomic ,strong) THDateFieldPicker     *dateEndPicker;
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);

@property (nonatomic, assign) BOOL     openFormat;
@property (nonatomic, assign) BOOL     openRange;
@property (nonatomic, assign) NSInteger formatRange;
@property (nonatomic,   weak) THScreenDateM     *cellModel;
@end
@implementation THScreenDateCell
+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenDateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)setupUI{
    [super setupUI];
    [self.contentView addSubview:self.datePicker];//开始时间
}
- (void)setupDataModel:(THScreenBaseM *)model{
    [super setupDataModel:model];
    
    self.cellModel = (THScreenDateM *)model;
    self.openFormat = self.cellModel.openFormat;
    self.openRange = self.cellModel.openRange;
    self.formatRange = self.cellModel.formatRange;
    
    if(self.openRange){//开启范围选择
        [self.contentView addSubview:self.dateEndPicker];
    }
    if(model.valueChanged){
        self.valueChanged = model.valueChanged;
    }
    if(self.openFormat){//开启自定义选择
        [self.contentView addSubview:self.typePicker];
        self.datePicker.pickerViewMode  = THDateFiledYearMode;
        if(self.openRange){
            self.dateEndPicker.pickerViewMode  = THDateFiledYearMode;
        }
        //设置范围宽度
        NSMutableArray *typePickDate = [NSMutableArray new];
        [typePickDate addObject:@{@"5":@"年维度"}];
        [typePickDate addObject:@{@"4":@"月维度"}];
        [typePickDate addObject:@{@"3":@"日维度"}];
        [typePickDate addObject:@{@"2":@"时维度"}];
        [typePickDate addObject:@{@"1":@"分维度"}];
        [typePickDate addObject:@{@"0":@"秒维度"}];
        if(self.cellModel.formatRange >= 1){
            [typePickDate removeObjectAtIndex:5];
        }
        if(self.cellModel.formatRange >= 2){
            [typePickDate removeObjectAtIndex:4];
        }
        if(self.cellModel.formatRange >= 3){
            [typePickDate removeObjectAtIndex:3];
        }
        if(self.cellModel.formatRange >= 4){
            [typePickDate removeObjectAtIndex:2];
        }
        if(self.cellModel.formatRange >= 5){
            [typePickDate removeObjectAtIndex:1];
        }
        self.typePicker.pickerData = typePickDate;
        
        self.typePicker.val = [NSString stringWithFormat:@"%ld",self.cellModel.formatRange];
    }
    
    //最后设置默认信息（format）
    if(self.cellModel.defaultFormat != 0){
        self.datePicker.pickerViewMode = self.cellModel.defaultFormat;
        if(self.cellModel.openRange){//开启范围选择，结束时间也要设置
            self.dateEndPicker.pickerViewMode = self.cellModel.defaultFormat;
        }
        if(self.cellModel.openFormat){
            self.typePicker.val = [NSString stringWithFormat:@"%ld",self.cellModel.defaultFormat];
        }
    }
    
    //值
    NSString *value = (self.cellModel.value)?self.cellModel.value:@"";
    NSArray *values = [value componentsSeparatedByString:@","];
    if(!self.openFormat && !self.openRange){//单个选择时间
        self.datePicker.text = value;
    }
    if(self.openFormat && !self.openRange){//开启自定义&&选择单个时间
        self.datePicker.text = values[0];
        if(values.count>1) self.typePicker.val = values[1];
    }
    if(!self.openFormat && self.openRange){//未开启自定义&&选择时间范围
        self.datePicker.text = values[0];
        self.dateEndPicker.text = (values.count>1)?values[1]:@"";
        
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text];
    }
    if(self.openFormat && self.openRange){//开启自定义&&选择时间范围
        self.datePicker.text = values[0];
        if(values.count>1) self.dateEndPicker.text = values[1];
        if(values.count>2) self.typePicker.val = values[2];
    }
    
    //最最后设置约束
    if(!self.openFormat && !self.openRange){//单个选择时间
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.right.equalTo(self.contentView).offset(-15.0);
            make.height.mas_equalTo(30.0);
        }];
    }
    if(self.openFormat && !self.openRange){//开启自定义&&选择单个时间
        [self.typePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
        }];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typePicker.mas_right).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
            make.width.equalTo(self.typePicker.mas_width);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
    }
    if(!self.openFormat && self.openRange){//未开启自定义&&选择时间范围
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
        }];
        [self.dateEndPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(44.0);
            make.left.equalTo(self.datePicker.mas_right).offset(15.0);
            make.height.mas_equalTo(30.0);
            make.width.equalTo(self.datePicker.mas_width);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
    }
    if(self.openFormat && self.openRange){//开启自定义&&选择时间范围
        [self.typePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
        }];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typePicker.mas_right).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
            make.width.equalTo(self.typePicker.mas_width);
        }];
        [self.dateEndPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.datePicker.mas_right).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
            make.width.equalTo(self.typePicker.mas_width);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
    }
}

- (THTextFieldPicker *)typePicker{
    if(!_typePicker){
        _typePicker                     = [THTextFieldPicker creatTextFiledWithStyle:THTextFiledCommonPicker];
        _typePicker.font                = [UIFont systemFontOfSize:13];
        _typePicker.borderStyle         = UITextBorderStyleNone;
        _typePicker.backgroundColor     = [UIColor whiteColor];
        _typePicker.leftView            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _typePicker.leftViewMode        = UITextFieldViewModeAlways;
        _typePicker.placeholder     = @"请选择";
        [_typePicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_typePicker radio:2];
    }
    return _typePicker;
}

- (THDateFieldPicker *)datePicker{
    if(!_datePicker){
        _datePicker                 = [[THDateFieldPicker alloc]init];
        _datePicker.font            = [UIFont systemFontOfSize:13];
        _datePicker.borderStyle     = UITextBorderStyleNone;
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _datePicker.leftViewMode    = UITextFieldViewModeAlways;
        _datePicker.placeholder     = @"请选择";
        [_datePicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_datePicker radio:2];
    }
    return _datePicker;
}

- (THDateFieldPicker *)dateEndPicker{
    if(!_dateEndPicker){
        _dateEndPicker                 = [[THDateFieldPicker alloc]init];
        _dateEndPicker.font            = [UIFont systemFontOfSize:13];
        _dateEndPicker.borderStyle     = UITextBorderStyleNone;
        _dateEndPicker.backgroundColor = [UIColor whiteColor];
        _dateEndPicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _dateEndPicker.leftViewMode    = UITextFieldViewModeAlways;
        _dateEndPicker.placeholder     = @"请选择";
        [_dateEndPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_dateEndPicker radio:2];
    }
    return _dateEndPicker;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    if(sender == self.typePicker){//如果选择的是方式
        THTextFieldPicker *picker = (THTextFieldPicker *)sender;
        self.datePicker.text = nil;
        self.dateEndPicker.text = nil;
        
        NSInteger mode = [picker.val integerValue];
        switch (mode) {
            case 0:self.datePicker.pickerViewMode = THDateFiledSecondMode;break;
            case 1:self.datePicker.pickerViewMode = THDateFiledMinuteMode;break;
            case 2:self.datePicker.pickerViewMode = THDateFiledHourMode;break;
            case 3:self.datePicker.pickerViewMode = THDateFiledDayMode;break;
            case 4:self.datePicker.pickerViewMode = THDateFiledMonthMode;break;
            case 5:self.datePicker.pickerViewMode = THDateFiledYearMode;break;
            default: break;
        }
        if(self.openRange){
            switch (mode) {
                case 0:self.dateEndPicker.pickerViewMode = THDateFiledSecondMode;break;
                case 1:self.dateEndPicker.pickerViewMode = THDateFiledMinuteMode;break;
                case 2:self.dateEndPicker.pickerViewMode = THDateFiledHourMode;break;
                case 3:self.dateEndPicker.pickerViewMode = THDateFiledDayMode;break;
                case 4:self.dateEndPicker.pickerViewMode = THDateFiledMonthMode;break;
                case 5:self.dateEndPicker.pickerViewMode = THDateFiledYearMode;break;
                default: break;
            }
        }
    }
    
    //若开始时间大于截止时间，则将时间调换
    if (self.openRange && ![self.datePicker.text isEqualToString:@""] && ![self.dateEndPicker.text isEqualToString:@""]) {
        NSString *str1 = self.datePicker.text;
        NSString *str2 = self.dateEndPicker.text;
        NSString *formate;
        switch (self.typePicker.val.intValue) {
            case 0:formate = @"yyyy.MM.dd HH:mm:ss";break;
            case 1:formate = @"yyyy.MM HH:mm";break;
            case 2:formate = @"yyyy.MM.dd HH";break;
            case 3:formate = @"yyyy.MM.dd";break;
            case 4:formate = @"yyyy.MM";break;
            case 5:formate = @"yyyy";break;
            default:break;
        }
        NSInteger sp1 = [self timeSwitchTimestamp:str1 withDateFormat:formate];
        NSInteger sp2 = [self timeSwitchTimestamp:str2 withDateFormat:formate];
        if (sp1 > sp2) {
            self.datePicker.text = str2;
            self.dateEndPicker.text = str1;
        }
    }
    
    if(self.valueChanged){
        NSString *value = (self.openRange)?[NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text]:self.datePicker.text;
        self.valueChanged(value, self.identifier);
    }
    
    if(!self.openFormat && !self.openRange){//单个选择时间
       self.cellModel.value = self.datePicker.text;
    }
    if(self.openFormat && !self.openRange){//开启自定义&&选择单个时间
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.typePicker.val];
    }
    if(!self.openFormat && self.openRange){//未开启自定义&&选择时间范围
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text];
    }
    if(self.openFormat && self.openRange){//开启自定义&&选择时间范围
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@,%@",self.datePicker.text,self.dateEndPicker.text,self.typePicker.val];
    }
}

/** 时间字符串转时间戳*/
- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime withDateFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}


@end
