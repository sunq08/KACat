//
//  THDataImageCell.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataImageCell.h"
#import "THDataM.h"
@interface THDataImageCell()
@property (strong, nonatomic) UILabel       *title;
@property (strong, nonatomic) UIImageView   *image;
@end
@implementation THDataImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.image];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.width.equalTo(@(100.0));
        make.top.equalTo(self.contentView).offset(13.0);
        make.height.equalTo(@(18.0));
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(self.contentView).offset(10.0);
//        make.bottom.equalTo(self.contentView).offset(-10.0);
        make.height.width.equalTo(@(60.0));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self.contentView);
        make.top.equalTo(self.image.mas_bottom).offset(10.0);
        make.bottom.equalTo(self.contentView);
    }];
}
- (UILabel *)title{
    if(!_title){
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}
- (UIImageView *)image{
    if(!_image){
        _image = [[UIImageView alloc]init];
        [_image.layer setCornerRadius:30];
        [_image.layer setMasksToBounds:YES];
    }
    return _image;
}

- (void)configCellModel:(THDataM *)model{
    if(model.cellType == 1){
        self.title.text = model.title;
        [self.image sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    }
    self.accessoryType = model.accessoryType;
}
@end
