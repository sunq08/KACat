//
//  THFormDateCell.m
//  QIAQIA
//
//  Created by 孙强 on 2020/4/8.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "THFormDateCell.h"
#import "THTextFieldPicker.h"
#import "THFormDateM.h"
@interface THFormDateCell()
@property (nonatomic, strong) THFormDateM *model;
@property (nonatomic ,strong) THTextFieldPicker *mainPicker;//picker
@end

@implementation THFormDateCell
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel{
    self = [super initWithFrame:frame cellModel:cellModel];
    if (self) {
        self.model = (THFormDateM *)cellModel;
        [self initUI];
        [self reloadData];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.mainPicker];
    self.mainPicker.placeholder = [NSString stringWithFormat:@"请选择%@",self.model.title];

    [self.mainPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(110.0);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30.0);
    }];
}
- (void)reloadData{
    self.mainPicker.val = self.model.value;
}
- (THTextFieldPicker *)mainPicker{
    if(!_mainPicker){
        _mainPicker                 = [THTextFieldPicker textFiledPickerWithStyle:THTextFiledTimePicker];
        _mainPicker.font            = [UIFont systemFontOfSize:13];
        _mainPicker.borderStyle     = UITextBorderStyleNone;
        _mainPicker.backgroundColor = [UIColor whiteColor];
        [_mainPicker addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainPicker radio:2];
    }
    return _mainPicker;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    self.model.value = self.mainPicker.val;
}

@end
