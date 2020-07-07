//
//  THScreenMultiSelectCell.m
//  GYSA
//
//  Created by itonghui on 2019/10/25.
//  Copyright © 2019 itonghui. All rights reserved.
//

#import "THScreenMultiSelectCell.h"
#import "THTextFieldPicker.h"
#import "THScreenMultiSelectM.h"
#import "THKitConfig.h"

@interface THScreenMultiSelectCell()
@property (nonatomic ,strong) THTextFieldPicker *mainPicker;//
@property (nonatomic ,strong) THTextFieldPicker *secondPicker;
@property (nonatomic ,strong) THTextFieldPicker *thirdPicker;

@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);
@property (nonatomic,   weak) THScreenMultiSelectM     *cellModel;
@end

@implementation THScreenMultiSelectCell

+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenMultiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenMultiSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)setupUI{
    [super setupUI];
}
- (void)setupUIWithModel:(THScreenMultiSelectM *)model{
    if (model.columnCount == 2) {
         [self.contentView addSubview:self.mainPicker];
         [self.contentView addSubview:self.secondPicker];
        
        [self.mainPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
        }];
        
        [self.secondPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainPicker.mas_right).offset(15.0);
            make.height.top.width.equalTo(self.mainPicker);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
    }else if (model.columnCount == 3){
         [self.contentView addSubview:self.mainPicker];
         [self.contentView addSubview:self.secondPicker];
         [self.contentView addSubview:self.thirdPicker];
        
        [self.mainPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.top.equalTo(self.contentView).offset(44.0);
            make.height.mas_equalTo(30.0);
        }];
        
        [self.secondPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainPicker.mas_right).offset(15.0);
            make.height.top.width.equalTo(self.mainPicker);
        }];
        
        [self.thirdPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.secondPicker.mas_right).offset(15.0);
            make.height.top.width.equalTo(self.secondPicker);
            make.right.equalTo(self.contentView).offset(-15.0);
        }];
    }else{
     NSLog(@"THScreenMultiSelectM:columnCount赋值不准确，请检查");
    }
}
- (void)setupDataModel:(THScreenBaseM *)model{
    [super setupDataModel:model];
     //绘制多级选择框，UI只绘制一次
    if (!self.cellModel) {
        [self setupUIWithModel:(THScreenMultiSelectM *)model];
    }

    self.cellModel = (THScreenMultiSelectM *)model;
    
    if(model.valueChanged){
        self.valueChanged = model.valueChanged;
    }
    if(self.cellModel.pickerData){
        if (self.mainPicker.pickerData != self.cellModel.pickerData) {
            self.mainPicker.pickerData = self.cellModel.pickerData;
            self.mainPicker.text = nil;
            self.mainPicker.val  = @"";
        }
    }if(self.cellModel.pickerData2){
        if (self.secondPicker.pickerData != self.cellModel.pickerData2) {
            self.secondPicker.pickerData = self.cellModel.pickerData2;
            self.secondPicker.text = nil;
            self.secondPicker.val  = @"";
        }
    } if(self.cellModel.pickerData3){
        if (self.thirdPicker.pickerData != self.cellModel.pickerData3) {
            self.thirdPicker.pickerData = self.cellModel.pickerData3;
            self.thirdPicker.text = nil;
            self.thirdPicker.val  = @"";
        }
    }
}

- (THTextFieldPicker *)mainPicker{
    if(!_mainPicker){
        _mainPicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledCommonPicker];
        _mainPicker.font            = [UIFont systemFontOfSize:13];
        _mainPicker.borderStyle     = UITextBorderStyleNone;
        _mainPicker.backgroundColor = [UIColor whiteColor];
        _mainPicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _mainPicker.leftViewMode    = UITextFieldViewModeAlways;
        _mainPicker.placeholder     = @"请选择";
        [_mainPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainPicker radio:2];
    }
    return _mainPicker;
}
- (THTextFieldPicker *)secondPicker{
    if(!_secondPicker){
        _secondPicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledCommonPicker];
        _secondPicker.font            = [UIFont systemFontOfSize:13];
        _secondPicker.borderStyle     = UITextBorderStyleNone;
        _secondPicker.backgroundColor = [UIColor whiteColor];
        _secondPicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _secondPicker.leftViewMode    = UITextFieldViewModeAlways;
        _secondPicker.placeholder     = @"请选择";
        [_secondPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_secondPicker radio:2];
    }
    return _secondPicker;
}
- (THTextFieldPicker *)thirdPicker{
    if(!_thirdPicker){
        _thirdPicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledCommonPicker];
        _thirdPicker.font            = [UIFont systemFontOfSize:13];
        _thirdPicker.borderStyle     = UITextBorderStyleNone;
        _thirdPicker.backgroundColor = [UIColor whiteColor];
        _thirdPicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _thirdPicker.leftViewMode    = UITextFieldViewModeAlways;
        _thirdPicker.placeholder     = @"请选择";
        [_thirdPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainPicker radio:2];
    }
    return _thirdPicker;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    THTextFieldPicker *picker =  (THTextFieldPicker *)sender;
    
    if(self.valueChanged){
        //告知外部是几级picker，选择则的什么值
        if (sender == self.mainPicker) {
           self.valueChanged(picker.val, @"1");
        }else if (sender == self.secondPicker){
           self.valueChanged(picker.val, @"2");
        }else if (sender == self.thirdPicker){
           //self.valueChanged(picker.val, @"3");
        }
    }
    switch (self.cellModel.columnCount) {
        case 2:
            self.cellModel.value = [NSString stringWithFormat:@"%@,%@",self.mainPicker.val,self.secondPicker.val];
            break;
        case 3:
            self.cellModel.value = [NSString stringWithFormat:@"%@,%@,%@",self.mainPicker.val,self.secondPicker.val,self.thirdPicker.val];
            break;
        default:
            break;
    }
}


@end
