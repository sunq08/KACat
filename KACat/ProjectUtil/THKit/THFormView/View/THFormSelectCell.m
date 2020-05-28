//
//  THFormSelectCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormSelectCell.h"
#import "THTextFieldPicker.h"
#import "THFormSelectM.h"
#import "THKitConfig.h"
@interface THFormSelectCell()
@property (nonatomic, strong) THFormSelectM *model;
@property (nonatomic ,strong) THTextFieldPicker *mainPicker;//picker
@end
@implementation THFormSelectCell
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel{
    self = [super initWithFrame:frame cellModel:cellModel];
    if (self) {
        self.model = (THFormSelectM *)cellModel;
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
    self.mainPicker.pickerData = self.model.pickerData;
    self.mainPicker.val = self.model.value;
}
- (THTextFieldPicker *)mainPicker{
    if(!_mainPicker){
        _mainPicker                 = [THTextFieldPicker creatTextFiledWithStyle:THTextFiledCommonPicker];
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
