//
//  THFormTextCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormTextCell.h"
#import "THFormTextM.h"
#import "THTextField.h"
#import "THTextView.h"
@interface THFormTextCell()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) THFormTextM *model;
@property (nonatomic, strong) THTextField *mainTF;//tf
@property (nonatomic,   copy) ClickActionBlock  actionBlock;
@property (nonatomic, strong) THTextView *mainTV;//tv
@end
@implementation THFormTextCell
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel{
    self = [super initWithFrame:frame cellModel:cellModel];
    if (self) {
        self.model = (THFormTextM *)cellModel;
        [self initUI];
        [self reloadData];
    }
    return self;
}

- (void)initUI{
    if(self.model.isTextArea){
        [self addSubview:self.mainTV];
        self.mainTV.placeholder = [NSString stringWithFormat:@"请输入%@",self.model.title];
        self.mainTV.limitLength = [self.model.limitLength integerValue];
        self.mainTF.userInteractionEnabled = !self.model.disable;
        [self.mainTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(110.0);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(13.0);
            make.bottom.equalTo(self).offset(-13.0);
        }];
    }else{
        [self addSubview:self.mainTF];
        
        self.mainTF.keyboardType = self.model.keyboardType;
        self.mainTF.userInteractionEnabled = !self.model.disable;
        self.mainTF.limitLength = self.model.limitLength;
        if(self.model.actionBlock){
            self.actionBlock = self.model.actionBlock;
        }else self.actionBlock = nil;
        
        if(self.actionBlock){
            self.mainTF.placeholder = [NSString stringWithFormat:@"请选择%@",self.model.title];
        }else self.mainTF.placeholder = [NSString stringWithFormat:@"请输入%@",self.model.title];
        
        [self.mainTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(110.0);
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30.0);
        }];
    }
}
- (void)reloadData{
    if(self.model.isTextArea){
        self.mainTV.text = self.model.value;
    }else{
        self.mainTF.text = self.model.value;
        if(self.actionBlock && self.model.actionText){
            self.mainTF.text = self.model.actionText;
        }
    }
}

- (THTextField *)mainTF{
    if(!_mainTF){
        _mainTF                     = [[THTextField alloc]init];
        _mainTF.font                = [UIFont systemFontOfSize:13];
        _mainTF.borderStyle         = UITextBorderStyleNone;
        _mainTF.clearButtonMode     = UITextFieldViewModeWhileEditing;
        _mainTF.backgroundColor     = [UIColor whiteColor];
        _mainTF.placeholder         = @"请输入";
        _mainTF.delegate            = self;
        [_mainTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainTF radio:2];
    }
    return _mainTF;
}
- (THTextView *)mainTV{
    if(!_mainTV){
        _mainTV                     = [[THTextView alloc]init];
        _mainTV.frame               = CGRectMake(110, 13, THScreenWidth-110-15, 68);
        _mainTV.font                = [UIFont systemFontOfSize:13];
        _mainTV.backgroundColor     = [UIColor groupTableViewBackgroundColor];
        _mainTV.delegate            = self;
        [THKitConfig layoutViewRadioWith:_mainTV radio:3];
    }
    return _mainTV;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
    self.model.value = textView.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.actionBlock){
        self.actionBlock(self.identifier);
        return NO;
    }
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    //赋值给model
    self.model.value = self.mainTF.text;
}

@end
