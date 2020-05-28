//
//  THScreenCardCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenCardCell.h"
#import "THCardView.h"
#import "THScreenCardM.h"
@interface THScreenCardCell()
@property (nonatomic ,strong) THCardView *cardView;//cardView
@property (nonatomic,   copy) void (^valueChanged)(NSString *value,NSString *identifier);
@property (nonatomic,   weak) THScreenCardM     *cellModel;
@end
@implementation THScreenCardCell

+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (void)setupUI{
    [super setupUI];
    
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.top.equalTo(self.contentView).offset(44.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.bottom.equalTo(self.contentView).offset(-6.0);
    }];
}

- (void)setupDataModel:(THScreenBaseM *)model{
    [super setupDataModel:model];
    
    self.cellModel = (THScreenCardM *)model;
    //添加KVO监控变化
    if (model.valueChanged && !self.valueChanged) {
        self.valueChanged = model.valueChanged;
    }
    
    if(self.cellModel.allbtn){
        self.cardView.allbtn = YES;
    }
    if(self.cellModel.pickerData){
        if (self.cellModel.pickerData != self.cardView.pickerData) {
             self.cardView.pickerData = self.cellModel.pickerData;
        }
    } else self.cardView.pickerData = [NSMutableArray arrayWithCapacity:0];//避免重用问题
    
    if(self.cellModel.value){
        self.cardView.defaultValue = self.cellModel.value;
    }
}

- (void)resetValue{
    [self.cardView resetValue];
}

- (THCardView *)cardView{
    if(!_cardView){
        _cardView = [[THCardView alloc]init];
        _cardView.singleNum = 4;//每行四个
        __weak typeof(self) weakSelf = self;
        _cardView.valueChanged = ^(NSString * _Nonnull value) {
            [weakSelf cardViewValueChanged:value];
        };
    }
    return _cardView;
}

- (void)cardViewValueChanged:(NSString *)value{
    if (self.valueChanged) {
        self.valueChanged(value, self.identifier);
    }
    self.cellModel.value = self.cardView.selectValue?self.cardView.selectValue:@"";
}
@end
