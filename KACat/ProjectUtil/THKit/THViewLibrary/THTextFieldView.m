//
//  THTextFieldView.m
//  THKitProject
//
//  Created by 孙强 on 2020/5/29.
//  Copyright © 2020 sunq. All rights reserved.
//
static const CGFloat THTFViewMargin   = 15.0;//控件间距
#import "THTextFieldView.h"
#import "THTextField.h"
#import "THKitConfig.h"
@interface THTextFieldView()
@property (nonatomic, assign) THTextFieldViewType type;
@property (nonatomic, strong) UIImageView *mainIcon;
@property (nonatomic, strong) UILabel   *mainTitle;
@property (nonatomic, strong) THTextField *mainTF;
@property (nonatomic, strong) UILabel *bottomLine;
@end
@implementation THTextFieldView
+ (instancetype)textFieldViewType:(THTextFieldViewType)textFieldViewType{
    return [[THTextFieldView alloc]initWithFrame:CGRectZero type:textFieldViewType];
}

- (instancetype)initWithFrame:(CGRect)frame type:(THTextFieldViewType)textFieldViewType{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = textFieldViewType;
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width                 = self.frame.size.width;
    float height                = self.frame.size.height;
    
    if(self.type == THTextFieldViewTypePlain){
        if(CGSizeEqualToSize(self.iconSize, CGSizeZero)){
            self.iconSize = CGSizeMake(height-THTFViewMargin, height-THTFViewMargin);
        }
        
        float iconW                 = self.iconSize.width;
        float iconH                 = self.iconSize.height;
        self.mainIcon.frame         = CGRectMake(THTFViewMargin, THTFViewMargin, iconW, iconH);
        self.mainTF.frame           = CGRectMake(iconW+2*THTFViewMargin, THTFViewMargin, width-iconW-3*THTFViewMargin, 30);
        
        //纵向居中
        self.mainIcon.center        = CGPointMake(self.mainIcon.center.x, height/2);
        self.mainTF.center          = CGPointMake(self.mainTF.center.x, height/2);
    }else if (self.type == THTextFieldViewTypeTitle){
        if(self.titleWidth == 0){
            self.titleWidth = 88.0;
        }
        
        float titleW                = self.titleWidth;
        self.mainTitle.frame        = CGRectMake(THTFViewMargin, 0, titleW, 21);
        self.mainTF.frame           = CGRectMake(titleW+2*THTFViewMargin, 0, width-titleW-3*THTFViewMargin, 30);
        
        //纵向居中
        self.mainTitle.center       = CGPointMake(self.mainTitle.center.x, height/2);
        self.mainTF.center          = CGPointMake(self.mainTF.center.x, height/2);
    }else if (self.type == THTextFieldViewTypeSubTitle){
        if(self.titleWidth == 0){
            self.titleWidth = width - 2*THTFViewMargin;
        }
        self.mainTitle.frame        = CGRectMake(THTFViewMargin, 0, self.titleWidth, 21);
        self.mainTF.frame           = CGRectMake(THTFViewMargin, 21, self.titleWidth, 30);
    }
    
    self.bottomLine.frame       = CGRectMake(0, height-1, width, 1);
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    if(self.type == THTextFieldViewTypePlain){
        [self addSubview:self.mainIcon];
    }else if (self.type == THTextFieldViewTypeTitle){
        [self addSubview:self.mainTitle];
    }else if (self.type == THTextFieldViewTypeSubTitle){
        [self addSubview:self.mainTitle];
    }
    [self addSubview:self.mainTF];
    [self addSubview:self.bottomLine];
}

#pragma mark - setting UI
- (UIImageView *)mainIcon{
    if(!_mainIcon){
        _mainIcon = [[UIImageView alloc]init];
    }
    return _mainIcon;
}

- (THTextField *)mainTF{
    if(!_mainTF){
        _mainTF = [[THTextField alloc]init];
        _mainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mainTF.secureTextEntry = NO;
        _mainTF.font = [UIFont systemFontOfSize:15];
    }
    return _mainTF;
}

- (UILabel *)mainTitle{
    if(!_mainTitle){
        _mainTitle = [[UILabel alloc]init];
        _mainTitle.font = [UIFont systemFontOfSize:15];
        _mainTitle.textColor = [UIColor darkTextColor];
    }
    return _mainTitle;
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
    self.mainTitle.text = title;
    self.mainTF.placeholder = [NSString stringWithFormat:@"请输入%@",title];
}
- (void)setTitleAlign:(NSTextAlignment)titleAlign{
    _titleAlign = titleAlign;
    self.mainTitle.textAlignment = titleAlign;
}
- (void)setIconImage:(UIImage *)iconImage{
    _iconImage = iconImage;
    _mainIcon.image = iconImage;
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    _mainTF.placeholder = placeholder;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    _mainTF.keyboardType = _keyboardType;
}
- (void)setTextBorderStyle:(UITextBorderStyle)textBorderStyle{
    _textBorderStyle = textBorderStyle;
    _mainTF.borderStyle = textBorderStyle;
}
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    _mainTF.secureTextEntry = secureTextEntry;
}
- (void)setDisable:(BOOL)disable{
    _disable = disable;
    
    _mainTF.enabled = !disable;
}
- (void)setLimitLength:(NSNumber *)limitLength{
    _limitLength = limitLength;
    
    _mainTF.limitLength = limitLength;
}
- (void)setFont:(UIFont *)font{
    _font = font;
    _mainTF.font = font;
}
- (void)setText:(NSString *)text{
    _mainTF.text = text?:@"";
}
- (NSString *)text{
    return _mainTF.text;
}
@end
