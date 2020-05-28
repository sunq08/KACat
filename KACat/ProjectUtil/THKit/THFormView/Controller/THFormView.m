//
//  THFormView.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormView.h"
#import "THFormBaseCell.h"
#import "THKitConfig.h"
@interface THFormView()
@property (nonatomic, strong) UIScrollView      *mainScroll;    //内容scroll
@property (nonatomic, strong) UIButton          *sureBtn;       //确定按钮
@property (nonatomic, strong) NSMutableArray    *models;        //内容list
@end
@implementation THFormView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.mainScroll];
    [self addSubview:self.sureBtn];
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    self.mainScroll.frame = CGRectMake(0, 0, width, height-56);
    self.sureBtn.frame = CGRectMake(30, height-56, width-60, 36);
}

- (UIScrollView *)mainScroll{
    if(!_mainScroll){
        _mainScroll = [[UIScrollView alloc]init];
    }
    return _mainScroll;
}

- (UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = THCommonBGColor;
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)reloadData{
    NSInteger num = 0;
    if(!self.models) self.models = [NSMutableArray new];
    
    [self.models removeAllObjects];
    if ([self.delegate respondsToSelector:@selector(numberOfIndexInFormView:)]) {
        num = [self.delegate numberOfIndexInFormView:self];
    }
    
    float width = self.frame.size.width;
    float viewH = 0;
    for (int index = 0; index < num; index ++) {
        CGRect rect = CGRectMake(0, viewH, width, 44.0);
        THFormBaseM *model = [self.delegate formView:self cellModelForIndex:index];
        [self.models addObject:model];
        if([model.cellClass isEqualToString:@"THFormTextCell"]){
            THFormTextM *textM = (THFormTextM *)model;
            if(textM.isTextArea) rect.size.height = 94.0;
        } else if ([model.cellClass isEqualToString:@"THFormImageCell"]){
            rect.size.height = 44.0+88.0;
        }
        
        Class class = NSClassFromString(model.cellClass);
        THFormBaseCell *cell = [[class alloc]initWithFrame:rect cellModel:model];
        cell.mustSign = self.mustSign;
        [self.mainScroll addSubview:cell];
        viewH += rect.size.height;
    }
    self.mainScroll.contentSize = CGSizeMake(width, viewH);
    
    if([self.delegate respondsToSelector:@selector(formView:buttonStyle:)]){
        [self.delegate formView:self buttonStyle:self.sureBtn];
    }
}

- (void)sureClick{
    if(![self.delegate respondsToSelector:@selector(formView:didSubmitClick:)]){
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int index = 0; index < self.models.count; index ++) {
        THFormBaseM *model = [self.models objectAtIndex:index];
        [dict addEntriesFromDictionary:model.data];
    }
    [self.delegate formView:self didSubmitClick:dict];
}

/** 刷新某一个cell，用于修改标题/cell的数据源*/
- (void)reloadCellWith:(NSInteger)index{
    if(index >= self.models.count){
        NSLog(@"数组越界了！检查一下是不是哪里写错了");
        return;
    }
    THFormBaseM *model = [self.models objectAtIndex:index];
    for (THFormBaseCell *cell in self.mainScroll.subviews) {
        if([cell isKindOfClass:[THFormBaseCell class]] && [cell.identifier isEqualToString:model.identifier]){
            [cell reloadData];
            break;
        }
    }
}

- (NSString *)validForm{
    NSString *result = @"";
    for (THFormBaseM *model in self.models) {
        result = [model validFormCell];
        if(![result isEqualToString:@""]){
            break;
        }
    }
    return result;
}

- (void)setDisable:(BOOL)disable{
    for (int index = 0; index < self.models.count; index ++) {
        THFormBaseM *model = [self.models objectAtIndex:index];
        model.disable = YES;
    }
    for (THFormBaseCell *cell in self.mainScroll.subviews) {
        if([cell isKindOfClass:[THFormBaseCell class]]){
            [cell reloadData];
        }
    }
}
@end
