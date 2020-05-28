//
//  THSortView.m
//  GYSA
//
//  Created by SunQ on 2019/8/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THSortView.h"
#import "THKitConfig.h"
@implementation THSortItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.autoresizesSubviews = NO;
    
    [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIColor *select = [UIColor colorWithRed:21./255. green:95./255. blue:210./255. alpha:1.];
    [self setTitleColor:select forState:UIControlStateSelected];
    [self setImage:[UIImage imageNamed:@"th-base-sort"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"th-base-sortH"] forState:UIControlStateSelected];
    
    [self invalidateIntrinsicContentSize];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGSize size = [super titleRectForContentRect:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX)].size;
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentFill) {
        size.height = MIN(size.height, CGRectGetHeight(contentRect));
    }
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
        size.width = MIN(size.width, CGRectGetWidth(contentRect));
    };
    CGSize iconSize = CGSizeMake(12, 8);
    CGFloat margin = 2.0;
    if (CGSizeEqualToSize(iconSize, CGSizeZero)) {
        margin = 0;
    }
    CGFloat totalWidth = size.width + iconSize.width + margin;
    CGRect rect = {{0, 0}, size};
    rect.origin.x = CGRectGetMinX(contentRect) + (CGRectGetWidth(contentRect) - totalWidth) / 2;
    rect.origin.y = CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - size.height) / 2;
    return CGRectIntegral(rect);
}


- (CGSize)titleSize{
    CGSize size = CGSizeZero;
    if (self.currentAttributedTitle) {
        size = [self.currentAttributedTitle size];
    }
    else if (self.currentTitle) {
        size = [self.currentTitle sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    }
    return size;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGSize size = CGSizeMake(12, 8);
    if (self.contentVerticalAlignment == UIControlContentVerticalAlignmentFill) {
        size.height = MIN(size.height, CGRectGetHeight(contentRect));
    }
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill) {
        size.width = MIN(size.width, CGRectGetWidth(contentRect));
    };
    CGSize titleSize = [self titleSize];
    CGFloat margin = 2.0;
    if (CGSizeEqualToSize(titleSize, CGSizeZero)) {
        margin = 0;
    }
    size.width = MAX(MIN(CGRectGetWidth(contentRect) - margin - titleSize.width, size.width), size.width);
    CGFloat totalWidth = size.width + titleSize.width + margin;
    CGRect rect = {{0, 0}, size};
    rect.origin.x = CGRectGetMinX(contentRect) + CGRectGetWidth(contentRect) - (CGRectGetWidth(contentRect) - totalWidth) / 2 - size.width;
    rect.origin.y = CGRectGetMinY(contentRect) + (CGRectGetHeight(contentRect) - size.height) / 2;
    return rect;
}


- (void)setSenderTitle:(NSString *)senderTitle{
    _senderTitle = senderTitle;
    [self setTitle:senderTitle forState:UIControlStateNormal];
}
@end


@interface THSortView()
@property (nonatomic, strong) UIButton *screenButton;//
@end

@implementation THSortView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initUI];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    float viewX = 0;
    float width = self.frame.size.width/self.subviews.count;
    for (THSortItem *sender in self.subviews) {
        sender.frame = CGRectMake(viewX, 0, width, self.frame.size.height);
        viewX+= width;
    }
}

- (void)reloadData{
    NSArray *titles = [self.delegate titlesWithSortView:self];
    int index = 0;
    for (NSDictionary *dict in titles) {
        NSString *title = [dict allValues][0];
        NSString *identifier = [dict allKeys][0];
        THSortItem *sender = [THSortItem buttonWithType:UIButtonTypeCustom];
        sender.senderTitle = title;
        sender.identifier = identifier;
        
        [sender addTarget:self action:@selector(sortClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(self.defaultSelectIndex && [self.defaultSelectIndex integerValue] == index){
            sender.selected = YES;
        }
        index ++;
        [self addSubview:sender];
    }
    
    if(self.showScreen){
        [self addSubview:self.screenButton];
    }
}

- (UIButton *)screenButton{
    if(!_screenButton){
        _screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenButton setTitle:@"筛选" forState:UIControlStateNormal];
        [_screenButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_screenButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_screenButton addTarget:self action:@selector(screenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _screenButton;
}

- (void)sortClick:(THSortItem *)sender{
    if(sender.selected){
        return;
    }
    for (THSortItem *button in [sender.superview subviews]) {
        if([button isKindOfClass:[THSortItem class]]){
            button.selected = NO;
        }
    }
    sender.selected = YES;
    if([self.delegate respondsToSelector:@selector(sortView:didSelectItemWithId:)]){
        [self.delegate sortView:self didSelectItemWithId:sender.identifier];
    }
}

- (void)screenClick:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(sortViewDidSelectScreen:)]){
        [self.delegate sortViewDidSelectScreen:self];
    }
}

@end
