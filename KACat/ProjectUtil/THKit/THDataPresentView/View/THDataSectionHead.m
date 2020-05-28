//
//  THDataSectionHead.m
//  GYSA
//
//  Created by SunQ on 2019/9/3.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataSectionHead.h"
@interface THDataSectionHead()
@property (strong, nonatomic) UILabel *line;
@end
@implementation THDataSectionHead

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.bottom.equalTo(self);
        make.right.equalTo(self).offset(-8.0);
    }];
    
    self.line = [[UILabel alloc]init];
    self.line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:self.line];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@(1.0));
    }];
}

- (UILabel *)textLabel{
    if(!_textLabel){
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}
@end
