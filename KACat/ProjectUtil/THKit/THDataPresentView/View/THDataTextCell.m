//
//  THDataTextCell.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataTextCell.h"
#import "THDataM.h"
@interface THDataTextCell()
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UILabel *title;
@end
@implementation THDataTextCell

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
    [self.contentView addSubview:self.detail];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.width.equalTo(@(100.0));
        make.top.equalTo(self.contentView).offset(13.0);
        make.height.equalTo(@(18.0));
    }];
    [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title.mas_right).offset(8.0);
        make.right.equalTo(self.contentView).offset(-15.0);
        make.top.equalTo(self.contentView).offset(13.0);
        make.bottom.equalTo(self.contentView).offset(-13.5);
        make.height.greaterThanOrEqualTo(@(17.0));
    }];
}
- (UILabel *)title{
    if(!_title){
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}
- (UILabel *)detail{
    if(!_detail){
        _detail = [[UILabel alloc]init];
        _detail.font = [UIFont systemFontOfSize:14];
        _detail.textColor = [UIColor darkGrayColor];
        _detail.lineBreakMode = NSLineBreakByCharWrapping;
        _detail.numberOfLines = 0;
    }
    return _detail;
}

- (void)configCellModel:(THDataM *)model{
    if(model.cellType == 0){
        self.title.text = model.title;
        self.detail.text = model.detail?model.detail:@"";
        if(model.detailColor){
            self.detail.textColor = model.detailColor;
        }
    }else if (model.cellType == 2){
        NSString *htmlStr = model.htmlStr?model.htmlStr:@"";
        //富文本
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)};
        NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
        //设置富文本
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
        //设置段落格式
        NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
        [attStr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attStr.length)];
        //设置文本的Font没有效果，默认12字号，这个只能服务器端控制吗？ 暂时没有找到方法修改字号
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attStr.length)];
        
        self.title.text = model.title;
        self.detail.attributedText = attStr;
    }
    self.detail.textAlignment = model.textAlignment;
    self.accessoryType = model.accessoryType;
}
@end
