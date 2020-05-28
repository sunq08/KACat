//
//  THTextField.m
//  GYSA
//
//  Created by SunQ on 2019/8/26.
//  Copyright © 2019年 itonghui. All rights reserved.
//

static const CGFloat THTFMargin   = 15.0;//控件间距


#import "THTextField.h"
#import "THKitConfig.h"
@interface THTextField()
@property (nonatomic, assign) THTextFieldType type;
@property (nonatomic, strong) UIImageView *mainIcon;
@property (nonatomic, strong) UILabel   *mainTitle;
@property (nonatomic, strong) UITextField *mainTF;
@property (nonatomic, strong) UILabel *bottomLine;
@end
@implementation THTextField

+ (instancetype)textFieldViewType:(THTextFieldType)textFieldType{
    THTextField *textField = [[THTextField alloc]initWithFrame:CGRectZero type:textFieldType];
    return textField;
}

- (instancetype)initWithFrame:(CGRect)frame type:(THTextFieldType)textFieldType{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = textFieldType;
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width                 = self.frame.size.width;
    float height                = self.frame.size.height;
    
    if(self.type == THTextFieldTypePlain){
        if(CGSizeEqualToSize(self.iconSize, CGSizeZero)){
            self.iconSize = CGSizeMake(height-THTFMargin, height-THTFMargin);
        }
        
        float iconW                 = self.iconSize.width;
        float iconH                 = self.iconSize.height;
        self.mainIcon.frame         = CGRectMake(THTFMargin, THTFMargin, iconW, iconH);
        self.mainTF.frame           = CGRectMake(iconW+2*THTFMargin, THTFMargin, width-iconW-3*THTFMargin, 30);
        
        //纵向居中
        self.mainIcon.center        = CGPointMake(self.mainIcon.center.x, height/2);
        self.mainTF.center          = CGPointMake(self.mainTF.center.x, height/2);
    }else if (self.type == THTextFieldTypeTitle){
        if(self.titleWidth == 0){
            self.titleWidth = 88.0;
        }
        
        float titleW                = self.titleWidth;
        self.mainTitle.frame        = CGRectMake(THTFMargin, 0, titleW, 21);
        self.mainTF.frame           = CGRectMake(titleW+2*THTFMargin, 0, width-titleW-3*THTFMargin, 30);
        
        //纵向居中
        self.mainTitle.center       = CGPointMake(self.mainTitle.center.x, height/2);
        self.mainTF.center          = CGPointMake(self.mainTF.center.x, height/2);
    }
    
    self.bottomLine.frame       = CGRectMake(0, height-1, width, 1);
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    if(self.type == THTextFieldTypePlain){
        [self addSubview:self.mainIcon];
    }else if (self.type == THTextFieldTypeTitle){
        [self addSubview:self.mainTitle];
    }
    [self addSubview:self.mainTF];
    [self addSubview:self.bottomLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChanged:) name:UITextFieldTextDidChangeNotification object:self.mainTF];
}

#pragma mark - setting UI
- (UIImageView *)mainIcon{
    if(!_mainIcon){
        _mainIcon = [[UIImageView alloc]init];
    }
    return _mainIcon;
}

- (UITextField *)mainTF{
    if(!_mainTF){
        _mainTF = [[UITextField alloc]init];
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


- (void)textFieldTextChanged:(NSNotification *)notification {
    if (!self.limitLength) {//字数限制
        return;
    }
    NSString *keyboardType = self.textInputMode.primaryLanguage;
    if ([keyboardType isEqualToString:@"zh-Hans"]) {//对简体中文做特殊处理>>>>高亮拼写问题
        UITextRange *range = self.mainTF.markedTextRange;
        if (!range) {
            if (self.mainTF.text.length > [self.limitLength intValue]) {
                self.mainTF.text = [self.mainTF.text substringToIndex:[self.limitLength intValue]];
                NSLog(@"已经是最大字数");
            }else {/*有高亮不做限制*/}
        }
    }else {
        if ([self.mainTF.text length] > [self.limitLength intValue]) {
            self.mainTF.text = [self.mainTF.text substringToIndex:[self.limitLength intValue]];
            NSLog(@"已经是最大字数");
        }
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.mainTF];
}
@end
