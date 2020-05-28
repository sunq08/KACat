//
//  ThCommonCell.m
//  QIAQIA
//
//  Created by 孙强 on 2020/4/3.
//  Copyright © 2020 SunQ Tonghui Network Technology Co., Ltd. All rights reserved.
//

#import "ThCommonCell.h"
#import "THKitConfig.h"
#import "THCommonCellBut.h"
#import "THCommonConfigM.h"
static const float           THCommonButW      = 60.0;

@interface ThCommonCell()
//@property (nonatomic, assign) NSInteger contentNumber;//共有多少个内容行，默认为0
//@property (nonatomic, assign) BOOL openDouble;//
//@property (nonatomic, strong) NSArray *buttonList;//

@property (nonatomic, strong) THCommonConfigM *configM;//

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *textView;
@property (nonatomic, strong) UIView *buttonView;

@property (nonatomic, strong) UIImageView *sign;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end
@implementation ThCommonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier configM:(THCommonConfigM *)configM{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.configM = configM;
        [self initUI];
        [self configLayout];
    }
    return self;
}

- (void)initUI{
    self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.mainView = [[UIView alloc]init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    if(self.configM.style == THCommonConfigCard){
        [THKitConfig layoutViewRadioWith:self.mainView radio:5];
    }
    [self.contentView addSubview:self.mainView];
    
    self.headView = [[UIView alloc]init];
    [self.mainView addSubview:self.headView];
    
    self.sign = [[UIImageView alloc]init];
    [self.headView addSubview:self.sign];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.headView addSubview:self.titleLabel];
    
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13];
    self.subTitleLabel.textColor = THCommonBGColor;
    self.subTitleLabel.textAlignment = NSTextAlignmentRight;
    [self.headView addSubview:self.subTitleLabel];
    [THKitConfig layoutViewBottomLineWith:self.headView margin:8.0];
    
    self.textView = [[UIView alloc]init];
    [self.mainView addSubview:self.textView];
    if(self.configM.buttonList && self.configM.buttonList.count != 0){
        [THKitConfig layoutViewBottomLineWith:self.textView margin:8.0];
        self.buttonView = [[UIView alloc]init];
        [self.mainView addSubview:self.buttonView];
        
        for (NSDictionary *butD in self.configM.buttonList) {
            THCommonCellBut * button = [self creatCommonButton];
            button.identifier = [butD objectForKey:@"identifier"];
            [button setTitle:[butD objectForKey:@"title"] forState:UIControlStateNormal];
        }
    }
    
    for (int i = 0; i <= self.configM.contentNumber; i ++) {
        UILabel *label = [self creatCommonLabel];
        label.tag = (i+1);
    }
}

- (void)configLayout{
    if(self.configM.style == THCommonConfigCard){
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(8.0);
            make.left.equalTo(self.contentView).offset(8.0);
            make.right.equalTo(self.contentView).offset(-8.0);
            make.bottom.equalTo(self.contentView);
        }];
    }else{
        [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-8.0);
        }];
    }
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.mainView);
        make.height.mas_offset(36);
    }];
    if(self.configM.hasSign){
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.headView);
            make.left.equalTo(self.sign.mas_right).offset(8.0);
        }];
        [self.sign mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLabel);
            make.left.equalTo(self.headView).offset(8.0);
            make.size.mas_equalTo(self.configM.signSize);
        }];
    }else{
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.headView);
            make.left.equalTo(self.headView).offset(8.0);
        }];
    }
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.headView);
        make.right.equalTo(self.headView).offset(-8.0);
        make.width.mas_offset(72);
        make.left.equalTo(self.titleLabel.mas_right).offset(8.0);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom);
        make.left.right.equalTo(self.mainView);
        if(self.configM.openDouble){//双行设置高度
            make.height.mas_offset(ceilf(self.configM.contentNumber/2.0f)*27);
        }else make.height.mas_offset(27*self.configM.contentNumber);//单行
    }];
    
    float vertical = (self.configM.style == THCommonConfigCard)?16.0:0.0;
    if(self.configM.openDouble){
        float width = (THScreenWidth-24.0-vertical)/2;
        for (int i = 0; i < self.configM.contentNumber; i++) {
            UILabel *label = [self.textView viewWithTag:(i+1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, 27.0));
                make.top.equalTo(self.textView).offset((i/2)*27);
                make.left.equalTo(self.textView).offset(8+(i%2)*(width+8));
            }];
        }
    }else{
        float width = THScreenWidth-vertical-8.0;
        for (int i = 0; i < self.configM.contentNumber; i++) {
            UILabel *label = [self.textView viewWithTag:(i+1)];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, 27.0));
                make.top.equalTo(self.textView).offset(i*27);
                make.left.equalTo(self.textView).offset(8.0);
            }];
        }
    }
    
    if(self.configM.buttonList && self.configM.buttonList.count != 0){
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom);
            make.left.right.equalTo(self.mainView);
            make.height.mas_offset(40);
        }];
    }
}

#pragma mark - creat ui
- (UILabel *)creatCommonLabel{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    [self.textView addSubview:label];
    return label;
}

- (THCommonCellBut *)creatCommonButton{
    THCommonCellBut *button = [THCommonCellBut buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(8, 0, THCommonButW, 30);
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [THKitConfig layoutViewRadioWith:button radio:3];
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [button setTitleColor:THCommonBGColor forState:UIControlStateNormal];
    [self.buttonView addSubview:button];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.hidden = YES;
    return button;
}

- (void)buttonClick:(THCommonCellBut *)sender{
    [self.delegate commonCellButtonClickWithIdentifier:sender.identifier index:self.index];
}

#pragma mark - super set
- (void)setDataM:(THDataConfigM *)dataM{
    _dataM = dataM;
    
    if(dataM.sign && self.configM.hasSign){
        self.sign.image = dataM.sign;
    }
    
    if(dataM.title){//设置标题
        self.titleLabel.text = dataM.title;
    }
    if(dataM.subTitle){//设置副标题
        self.subTitleLabel.text = dataM.subTitle;
    }
    if(dataM.subTitleColor){
        self.subTitleLabel.textColor = dataM.subTitleColor;
    }
    //设置按钮
    for (UIView *sub in self.buttonView.subviews) {
        if([sub isKindOfClass:[UIButton class]]){
            sub.hidden = YES;
        }
    }
    
    if(dataM.buttons && dataM.buttons.count != 0){
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (NSString *identifier in dataM.buttons) {
            for (THCommonCellBut *sub in self.buttonView.subviews) {
                if([sub isKindOfClass:[THCommonCellBut class]]){
                    if([identifier isEqualToString:sub.identifier]){
                        [array addObject:sub];
                    }
                }
            }
        }
        
        for (int i = 0; i < [array count]; i++) {
            UIButton *button = [array objectAtIndex:i];
            button.hidden = NO;
            if(self.configM.style == THCommonConfigPlain){
                button.frame = CGRectMake(THScreenWidth-68*(i+1), 5, THCommonButW, 30);
            }else button.frame = CGRectMake((THScreenWidth-12)-68*(i+1), 5, THCommonButW, 30);
        }
    }
    
    //设置内容
    if(!dataM.contents || dataM.contents.count != self.configM.contentNumber){
        NSLog(@"数据源数量与配置项不符，请检查代码！");
        return;
    }
    NSInteger i = 0;
    for (NSString *text in dataM.contents) {
        UILabel *label = [self.textView viewWithTag:(i+1)];
        label.text = text;
        i ++;
    }
}

@end
