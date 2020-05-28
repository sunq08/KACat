//
//  THMessageView.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

static const CGFloat THMSGMargin   = 8.0;//控件间距
static const CGFloat THMSGTitleW   = 72.0;//标题宽度

#import "THMessageView.h"
#import "THKitConfig.h"
@interface THMessageView()
@property (nonatomic, assign) THMessageViewType type;
@property (nonatomic, strong) UILabel   *titleLab;
@property (nonatomic, strong) UILabel   *detailLab;
@property (nonatomic, strong) UILabel   *bottomLine;
@end
@implementation THMessageView

+ (instancetype)messageViewType:(THMessageViewType)messageViewType{
    THMessageView *view = [[THMessageView alloc]initWithFrame:CGRectZero type:messageViewType];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame type:(THMessageViewType)messageViewType{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = messageViewType;
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.titleLab];
    [self addSubview:self.detailLab];
    [self addSubview:self.bottomLine];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLab.mas_top);
        make.left.equalTo(self).offset(THMSGMargin);
        make.width.mas_equalTo(THMSGTitleW);
        make.right.equalTo(self.detailLab.mas_left).offset(-THMSGMargin);
    }];
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(13.0);
        make.bottom.equalTo(self).offset(-13.0);
        make.height.greaterThanOrEqualTo(@18.0);
        make.right.equalTo(self).offset(-THMSGMargin);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1.0);
    }];
}

#pragma mark - setting UI
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textColor = [UIColor darkTextColor];
    }
    return _titleLab;
}

- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [[UILabel alloc]init];
        _detailLab.font = [UIFont systemFontOfSize:15];
        _detailLab.numberOfLines = 0;
        _detailLab.textColor = [UIColor darkGrayColor];
        _detailLab.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _detailLab;
}

- (UILabel *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [[UILabel alloc]init];
        _bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLine;
}

#pragma mark - setting attribute
- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLab.text = title;
}

- (void)setTitleAlign:(NSTextAlignment)titleAlign{
    _titleAlign = titleAlign;
    self.titleLab.textAlignment = titleAlign;
}

- (void)setText:(NSString *)text{
    _text = text;
    
    if(self.type == THTextMessageTypePlain){
        self.detailLab.text = text;
    }else{
        NSString *htmlStr = text?text:@"";
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
        
        self.detailLab.attributedText = attStr;
    }
}


- (void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    self.bottomLine.hidden = hideLine;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    _numberOfLines = numberOfLines;
    
    self.detailLab.numberOfLines = numberOfLines;
}

- (CGFloat)getViewHeight{
    return 44.0;
}
@end
