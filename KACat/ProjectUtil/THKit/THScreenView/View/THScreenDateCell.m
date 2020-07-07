//
//  THScreenDateCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenDateCell.h"
#import "THTextFieldPicker.h"
#import "THScreenDateM.h"
#import "THKitConfig.h"
@interface THScreenDateCell()
@property (nonatomic ,strong) THTextFieldPicker     *datePicker;
@property (nonatomic ,strong) THTextFieldPicker     *dateEndPicker;
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);

@property (nonatomic, assign) BOOL     openRange;
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
    self.openRange = self.cellModel.openRange;
    
    if(self.openRange){//开启范围选择
        [self.contentView addSubview:self.dateEndPicker];
    }
    if(model.valueChanged){
        self.valueChanged = model.valueChanged;
    }
    
    //值
    NSString *value = (self.cellModel.value)?self.cellModel.value:@"";
    NSArray *values = [value componentsSeparatedByString:@","];
    if(self.openRange){//选择时间范围
        self.datePicker.text = values[0];
        self.dateEndPicker.text = (values.count>1)?values[1]:@"";
        
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text];
        self.datePicker.dateFormate = self.cellModel.format;
        self.dateEndPicker.dateFormate = self.cellModel.format;
    }else{//单个选择时间
        self.datePicker.text = value;
        self.datePicker.dateFormate = self.cellModel.format;
    }
    
    //最最后设置约束
    if(self.openRange){//选择时间范围
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
    }else{//单个选择时间
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.right.equalTo(self.contentView).offset(-15.0);
            make.height.mas_equalTo(30.0);
        }];
    }
}

- (THTextFieldPicker *)datePicker{
    if(!_datePicker){
        _datePicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledTimePicker];
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

- (THTextFieldPicker *)dateEndPicker{
    if(!_dateEndPicker){
        _dateEndPicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledTimePicker];
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
    //若开始时间大于截止时间，则将时间调换
    if (self.openRange && ![self.datePicker.text isEqualToString:@""] && ![self.dateEndPicker.text isEqualToString:@""]) {
        NSString *str1 = self.datePicker.text;
        NSString *str2 = self.dateEndPicker.text;
        NSString *format = self.cellModel.format;
        NSInteger sp1 = [self timeSwitchTimestamp:str1 withDateFormat:format];
        NSInteger sp2 = [self timeSwitchTimestamp:str2 withDateFormat:format];
        if (sp1 > sp2) {
            self.datePicker.text = str2;
            self.dateEndPicker.text = str1;
        }
    }
    
    if(self.valueChanged){
        NSString *value = (self.openRange)?[NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text]:self.datePicker.text;
        self.valueChanged(value, self.identifier);
    }
    
    if(!self.openRange){//单个选择时间
       self.cellModel.value = self.datePicker.text;
    }
    if(self.openRange){//未开启自定义&&选择时间范围
        self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.datePicker.text,self.dateEndPicker.text];
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
