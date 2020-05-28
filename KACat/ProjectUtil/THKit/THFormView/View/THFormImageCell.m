//
//  THFormImageCell.m
//  GYSA
//
//  Created by SunQ on 2019/10/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THFormImageCell.h"
#import "THImagePreview.h"
#import "THFormImageM.h"
#import "THKitConfig.h"
@interface THFormImageCell()
@property (nonatomic, strong) THFormImageM *model;
@property (nonatomic, strong) THImagePreview *imagePreview;
@end
@implementation THFormImageCell
- (instancetype)initWithFrame:(CGRect)frame cellModel:(THFormBaseM *)cellModel{
    self = [super initWithFrame:frame cellModel:cellModel];
    if (self) {
        self.model = (THFormImageM *)cellModel;
        [self initUI];
        [self reloadData];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.imagePreview];
    [self.imagePreview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(44.0);
        make.right.equalTo(self).offset(-15);
        make.height.mas_equalTo(80.0);
    }];
}
- (void)reloadData{
    [self.imagePreview updateImagesWith:self.model.urls ids:self.model.ids];
}
- (THImagePreview *)imagePreview{
    if(!_imagePreview){
        _imagePreview = [[THImagePreview alloc]initWithFrame:CGRectMake(15, 44, THScreenWidth-30, 80) style:THImageStyleEdit];
        __weak typeof(self) weakSelf = self;
        _imagePreview.imageAddClick = ^(NSInteger imageCount){
            BOOL overflow = (imageCount>=weakSelf.model.maxCount);
            weakSelf.model.imageAddClick(overflow);
        };
        _imagePreview.imageChanged = ^(NSMutableArray * _Nonnull fileIds) {
            weakSelf.model.ids = fileIds;
        };
    }
    return _imagePreview;
}
@end
