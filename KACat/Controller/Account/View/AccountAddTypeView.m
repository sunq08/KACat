//
//  AccountAddTypeView.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/10.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "AccountAddTypeView.h"
@interface AccountAddTypeView ()
@property (nonatomic, strong) UIView *mainView;//弹框视图
@end
@implementation AccountAddTypeView
+ (AccountAddTypeView *)show{
    AccountAddTypeView *addView = [[AccountAddTypeView alloc] init];
    return addView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];

        [self initUI];
        
        [self showAnimation];
    }
    return self;
}

- (void)initUI{
    float width = MScreenWidth-100;
    float height = 250;
    
    self.mainView.frame = CGRectMake(50, (MScreenHeight-height)/2-100, width, height);
    [self addSubview:self.mainView];
    
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(0, 4, width, 21);
    title.font = SYSTEMFONT(15);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor hex:@"666666"];
    title.text = @"新增账户类型";
    [self.mainView addSubview:title];
    
    UITextField *name = [[UITextField alloc]init];
    name.placeholder = @"请输入账户名称";
    name.frame = CGRectMake(8, title.bottom + 8, width - 16, 28);
    [self.mainView addSubview:name];
}

- (void)showAnimation{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.mainView.alpha = 0.0;
    [UIView animateWithDuration:0.05 animations:^{
        self.mainView.alpha = 1;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 8;
        _mainView.layer.masksToBounds = YES;
    }
    return _mainView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.mainView frame], pt)) {
        [self dismiss];
    }
}

@end
