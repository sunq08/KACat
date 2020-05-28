//
//  THScreenSelectCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenSelectCell.h"
#import "THTextFieldPicker.h"
#import "THScreenSelectM.h"
#import "THKitConfig.h"
@interface THScreenSelectCell()
@property (nonatomic ,strong) THTextFieldPicker *mainPicker;//
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);
@property (nonatomic,   weak) THScreenSelectM     *cellModel;
@end
@implementation THScreenSelectCell
+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)setupUI{
    [super setupUI];
    
    [self.contentView addSubview:self.mainPicker];
    [self.mainPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.top.equalTo(self.contentView).offset(44.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.height.mas_equalTo(30.0);
    }];
}
- (void)setupDataModel:(THScreenBaseM *)model{
    [super setupDataModel:model];
    
    self.cellModel = (THScreenSelectM *)model;
    
    if(self.cellModel.title){
        self.mainPicker.placeholder = [NSString stringWithFormat:@"请选择%@",self.cellModel.title];
    }
    if(model.valueChanged){
        self.valueChanged = model.valueChanged;
    }
    if(self.cellModel.pickerData){
        if (self.mainPicker.pickerData != self.cellModel.pickerData) {
            self.mainPicker.pickerData = self.cellModel.pickerData;
            self.mainPicker.text = nil;
            self.mainPicker.val  = @"";
        }
    } else self.mainPicker.pickerData = [NSMutableArray arrayWithCapacity:0];//避免重用问题
    
    if(self.cellModel.value){
        self.mainPicker.val = self.cellModel.value;
    }
}

- (THTextFieldPicker *)mainPicker{
    if(!_mainPicker){
        _mainPicker                 = [THTextFieldPicker creatTextFiledWithStyle:THTextFiledCommonPicker];
        _mainPicker.font            = [UIFont systemFontOfSize:13];
        _mainPicker.borderStyle     = UITextBorderStyleNone;
        _mainPicker.backgroundColor = [UIColor whiteColor];
        _mainPicker.leftView        = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _mainPicker.leftViewMode    = UITextFieldViewModeAlways;
        [_mainPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainPicker radio:2];
    }
    return _mainPicker;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    if(self.valueChanged){
        self.valueChanged(self.mainPicker.val, self.identifier);
    }
    
    self.cellModel.value = self.mainPicker.val;
}

@end
