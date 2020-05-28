//
//  THFormBaseCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormBaseCell.h"
#import "THFormBaseM.h"
@interface THFormBaseCell()
@property (nonatomic, strong) UILabel *titleLab;//title
@property (nonatomic, strong) UILabel *lineLab;//line
@property (nonatomic,  copy, readwrite) NSString *identifier;
@end
@implementation THFormBaseCell

- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel {
    self = [super initWithFrame:frame];
    if (self) {
        [self initBaseWithModel:cellModel];
    }
    return self;
}

- (void)initBaseWithModel:(THFormBaseM *)cellModel{
    self.identifier = cellModel.identifier;
    [self addSubview:self.titleLab];
    [self addSubview:self.lineLab];
    self.titleLab.text = cellModel.title;
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13.0);
        make.left.equalTo(self).offset(15.0);
        make.height.mas_equalTo(18.0);
        make.width.mas_equalTo(80.0);
    }];
    [self.lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.bottom.equalTo(self);
        make.height.mas_equalTo(1.0);
    }];
}

- (void)reloadData{
    
}

- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab                   = [[UILabel alloc]init];
        _titleLab.textColor         = [UIColor darkGrayColor];
        _titleLab.font              = [UIFont systemFontOfSize:13];
    }
    return _titleLab;
}
- (UILabel *)lineLab{
    if(!_lineLab){
        _lineLab                   = [[UILabel alloc]init];
        _lineLab.backgroundColor   = [UIColor groupTableViewBackgroundColor];
    }
    return _lineLab;
}

- (void)setMustSign:(BOOL)mustSign{
    _mustSign = mustSign;
    
    NSString *title = self.titleLab.text;
    if(self.mustSign){
        NSString *str = [NSString stringWithFormat:@"*%@",title];
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
        self.titleLab.attributedText = AttributedStr;
    }
}
@end
