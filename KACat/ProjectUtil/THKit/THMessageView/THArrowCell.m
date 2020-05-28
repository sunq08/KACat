//
//  THArrowCell.m
//  GYSA
//
//  Created by SunQ on 2019/11/5.
//  Copyright © 2019 itonghui. All rights reserved.
//

static const CGFloat THMSGMargin   = 8.0;//控件间距
static const CGFloat THMSGTitleW   = 72.0;//标题宽度
static const CGFloat THMSGIconW    = 21.0;//图标宽高

#import "THArrowCell.h"
#import "THKitConfig.h"
@interface THArrowCell()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImageView *arrowImg;
@property (nonatomic, strong) CALayer     *bottomLine;
@property (nonatomic, strong) UILabel     *titleLab;
@property (nonatomic, strong) UILabel     *detailLab;
@end
@implementation THArrowCell
#pragma mark - Super Method
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.icon];
    [self addSubview:self.titleLab];
    [self addSubview:self.detailLab];
    [self addSubview:self.arrowImg];
    [self.layer addSublayer:self.bottomLine];
    
    //单击手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapRecognize];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    float viewX = THMSGMargin;
    if(self.mainImg){//有图标
        self.icon.frame = CGRectMake(viewX, 0, THMSGIconW, THMSGIconW);
        self.icon.center = CGPointMake(self.icon.center.x, height/2);
        viewX += (THMSGMargin + THMSGIconW);
    }
    self.titleLab.frame = CGRectMake(viewX, 0, THMSGTitleW, 21);
    self.titleLab.center = CGPointMake(self.titleLab.center.x, height/2);
    viewX += (THMSGMargin + THMSGTitleW);
    
    self.detailLab.frame = CGRectMake(viewX, 0, width-viewX-THMSGMargin-16, 30);
    self.detailLab.center = CGPointMake(self.detailLab.center.x, height/2);
    
    //arrow
    self.arrowImg.frame = CGRectMake(width - 16, 0, 8, 12);
    self.arrowImg.center = CGPointMake(self.arrowImg.center.x, height/2);
    
    //line
    if (self.lineToLeft) {
        [self.bottomLine setFrame:CGRectMake(0, height-1, width, 1)];
    }else [self.bottomLine setFrame:CGRectMake(THMSGMargin, height-1, width - THMSGMargin, 1)];
}

#pragma mark - ui
- (UIImageView *)icon{
    if(!_icon){
        _icon = [[UIImageView alloc]init];
    }
    return _icon;
}
- (UIImageView *)arrowImg{
    if(!_arrowImg){
        _arrowImg = [[UIImageView alloc]init];
        _arrowImg.image = [UIImage imageNamed:@"th-cell"];
    }
    return _arrowImg;
}
- (UILabel *)titleLab{
    if(!_titleLab){
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
- (UILabel *)detailLab{
    if(!_detailLab){
        _detailLab = [[UILabel alloc]init];
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.textColor = [UIColor lightGrayColor];
        _detailLab.font = [UIFont systemFontOfSize:14];
    }
    return _detailLab;
}
- (CALayer *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [CALayer layer];
        [_bottomLine setBackgroundColor:[UIColor groupTableViewBackgroundColor].CGColor];
    }
    return _bottomLine;
}

#pragma mark - setting
//设置图标
- (void)setMainImg:(UIImage *)mainImg{
    _mainImg = mainImg;
    _icon.image = mainImg;
}
//设置标题
- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLab.text = title;
}
//详细字体
- (void)setDetailTitle:(NSString *)detailTitle{
    _detailTitle = detailTitle;
    _detailLab.text = detailTitle;
}
//箭头显示与隐藏
- (void)setHideArrow:(BOOL)hideArrow{
    _hideArrow = hideArrow;
    _arrowImg.hidden = hideArrow;
}
//边线显示隐藏
- (void)setHideLine:(BOOL)hideLine{
    _hideLine = hideLine;
    if(hideLine) [_bottomLine removeFromSuperlayer];
    else [self.layer addSublayer:self.bottomLine];
}

-(void) handleTap:(UITapGestureRecognizer *)recognizer{
    if(self.actionBlock){
        self.actionBlock(self);
    }
}
@end
