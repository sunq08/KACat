//
//  THScreenTextCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenTextCell.h"
#import "THKitConfig.h"
#import "THScreenTextM.h"
@interface THScreenTextCell()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField       *mainTF;//tf
@property (nonatomic ,strong) UITextField       *secondTF;//tf
@property (nonatomic,   copy) ClickActionBlock  actionBlock;
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);
@property (nonatomic,   copy) NSString          *value;
@property (nonatomic, assign) BOOL              openRange;
@property (nonatomic, assign) NSInteger         maxLength;
@property (nonatomic,   weak) THScreenTextM     *cellModel;
@end
@implementation THScreenTextCell

+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (void)setupUI{
    [super setupUI];

    [self.contentView addSubview:self.mainTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:self.mainTF];
}
- (void)setupDataModel:(THScreenBaseM *)model{
    [super setupDataModel:model];
    
    self.cellModel = (THScreenTextM *)model;
    self.openRange = self.cellModel.openRange;
    self.maxLength = self.cellModel.maxLength;
    
    if(model.valueChanged){
        self.valueChanged = model.valueChanged;
    }
    
    //设置内容值
    if (self.cellModel.actionBlock) {//点击模式下
        self.mainTF.text = self.cellModel.actionText?self.cellModel.actionText:@"";
        self.value = self.cellModel.value?self.cellModel.value:@"";
    }else{//非点击模式
        NSString *value = (self.cellModel.value)?self.cellModel.value:@"";
        if(self.cellModel.openRange){//范围模式，用“,”分割
            if(![value isEqualToString:@""]){
                NSArray *values = [value componentsSeparatedByString:@","];
                self.mainTF.text = values[0];
                if(values.count>1) self.secondTF.text = values[1];
            }
        }else{//简易模式
            self.mainTF.text = value;
        }
    }
    
     if (self.openRange) {
         [self.contentView addSubview:self.secondTF];
         self.mainTF.placeholder = @"最低";
         self.mainTF.keyboardType = UIKeyboardTypeDecimalPad;
         self.secondTF.placeholder = @"最高";
         self.secondTF.keyboardType = UIKeyboardTypeDecimalPad;
         [self.mainTF mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.contentView).offset(15.0);
             make.top.equalTo(self.contentView).offset(44.0);
                 make.height.mas_equalTo(30.0);
         }];
         
         UILabel *label = [UILabel new];
         label.textColor = [UIColor darkGrayColor];
         label.textAlignment = NSTextAlignmentCenter;
         label.text     = @"~";
         [self.contentView addSubview:label];
         [label mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(self.mainTF.mas_right);
             make.top.equalTo(self.mainTF);
             make.height.mas_equalTo(30.0);
             make.width.mas_equalTo(40);
         }];
         
         [self.secondTF mas_makeConstraints:^(MASConstraintMaker *make) {
             make.left.equalTo(label.mas_right);
             make.top.width.height.equalTo(self.mainTF);
             make.right.equalTo(self.contentView).offset(-15.0);
         }];
         
     }else{
         if(self.cellModel.title){
             
         }
         if(self.cellModel.actionBlock){
             self.actionBlock = self.cellModel.actionBlock;
         }else self.actionBlock = nil;
         
         NSString *title = (self.cellModel.title)?self.cellModel.title:@"";
         if(self.actionBlock){
             self.mainTF.placeholder = [NSString stringWithFormat:@"请选择%@",title];
         }else self.mainTF.placeholder = [NSString stringWithFormat:@"请输入%@",title];
         
         [self.mainTF mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.equalTo(self.contentView).offset(15.0);
              make.top.equalTo(self.contentView).offset(44.0);
              make.right.equalTo(self.contentView).offset(-15.0);
              make.height.mas_equalTo(30.0);
          }];
     }
}
- (UITextField *)mainTF{
    if(!_mainTF){
        _mainTF                     = [[UITextField alloc]init];
        _mainTF.font                = [UIFont systemFontOfSize:13];
        _mainTF.borderStyle         = UITextBorderStyleNone;
        _mainTF.backgroundColor     = [UIColor whiteColor];
        _mainTF.delegate            = self;
        _mainTF.leftView            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _mainTF.leftViewMode        = UITextFieldViewModeAlways;
        [_mainTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_mainTF radio:2];
    }
    return _mainTF;
}
- (UITextField *)secondTF{
    if(!_secondTF){
        _secondTF                     = [[UITextField alloc]init];
        _secondTF.font                = [UIFont systemFontOfSize:13];
        _secondTF.borderStyle         = UITextBorderStyleNone;
        _secondTF.backgroundColor     = [UIColor whiteColor];
        _secondTF.delegate            = self;
        _secondTF.leftView            = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _secondTF.leftViewMode        = UITextFieldViewModeAlways;
        [_secondTF addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingDidEnd];
        [THKitConfig layoutViewRadioWith:_secondTF radio:2];
    }
    return _secondTF;
}

#pragma mark - text filed delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.actionBlock){
        self.actionBlock(self.identifier);
        return NO;
    }
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)sender{
    if(self.valueChanged){
        NSString *value = (self.openRange)?[NSString stringWithFormat:@"%@,%@",self.mainTF.text,self.secondTF.text]:self.mainTF.text;
        self.valueChanged(value, self.identifier);
    }
    //范围模式，1,先判断大小，是否要置换
    if (self.openRange&&self.mainTF.text.length>0 &&self.secondTF.text.length>0) {
        NSString *str1 = self.mainTF.text;
        NSString *str2 = self.secondTF.text;
        if (str1.doubleValue > str2.doubleValue) {
            self.mainTF.text = str2;
            self.secondTF.text = str1;
        }
    }
    //2,赋值给model
    NSString *value = self.mainTF.text;
    if(self.cellModel.openRange){
        value = [NSString stringWithFormat:@"%@,%@",value,self.secondTF.text];
    }
    self.cellModel.value = value;
}

- (void)textFieldTextChanged:(NSNotification *)notification {
    if (self.maxLength == 0) {//字数限制，0不限制
        return;
    }
    NSString *keyboardType = self.textInputMode.primaryLanguage;
    if ([keyboardType isEqualToString:@"zh-Hans"]) {//对简体中文做特殊处理>>>>高亮拼写问题
        UITextRange *range = self.mainTF.markedTextRange;
        if (!range) {
            if (self.mainTF.text.length > self.maxLength) {
                self.mainTF.text = [self.mainTF.text substringToIndex:self.maxLength];
                NSLog(@"已经是最大字数");
            }else {/*有高亮不做限制*/}
        }
    }else {
        if ([self.mainTF.text length] > self.maxLength) {
            self.mainTF.text = [self.mainTF.text substringToIndex:self.maxLength];
            NSLog(@"已经是最大字数");
        }
    }
}
@end
