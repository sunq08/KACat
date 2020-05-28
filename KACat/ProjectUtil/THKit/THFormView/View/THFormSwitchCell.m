//
//  THFormSwitchCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormSwitchCell.h"
#import "THFormSwitchM.h"
@interface THFormSwitchCell()
@property (nonatomic ,strong) UISwitch *mainSwitch;
@property (nonatomic, strong) THFormSwitchM *model;
@end
@implementation THFormSwitchCell
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel{
    self = [super initWithFrame:frame cellModel:cellModel];
    if (self) {
        self.model = (THFormSwitchM *)cellModel;
        [self initUI];
        [self reloadData];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.mainSwitch];
    [self.mainSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(110.0);
        make.centerY.equalTo(self);
    }];
}
- (void)reloadData{
    self.mainSwitch.on = (self.model.value && [self.model.value isEqualToString:@"1"])?YES:NO;
}
- (UISwitch *)mainSwitch{
    if (!_mainSwitch) {
        _mainSwitch = [[UISwitch alloc] init];
        [_mainSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _mainSwitch;
}
- (void)switchValueChanged:(UISwitch *)sender{
    self.model.value = (sender.on)?@"1":@"0";
}
@end
