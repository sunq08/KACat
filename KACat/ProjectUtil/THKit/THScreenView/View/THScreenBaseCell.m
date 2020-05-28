//
//  THScreenBaseCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/11.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseCell.h"
#import "THScreenBaseM.h"
@interface THScreenBaseCell()
@property (nonatomic,strong) UILabel *titleLab;
@end
@implementation THScreenBaseCell
+ (THScreenBaseCell *)cellWithIdentifier:(NSString *)cellIdentifier tableView:(UITableView *)tableView{
    THScreenBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[THScreenBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(15.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.height.mas_equalTo(21);
    }];
}

- (void)setupDataModel:(THScreenBaseM *)model{
    self.identifier = model.identifier;
    if(model.title){
        if(model.mustSign){
            NSString *str = [NSString stringWithFormat:@"*%@",model.title];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
            self.titleLab.attributedText = AttributedStr;
        }else self.titleLab.text = model.title;
    }
}

#pragma mark - supper get
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab                   = [[UILabel alloc]init];
        _titleLab.textColor         = [UIColor darkGrayColor];
        _titleLab.font              = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}


@end
