//
//  THDataImagesCell.m
//  GYSA
//
//  Created by SunQ on 2019/9/2.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THDataImagesCell.h"
#import "THDataM.h"
#import "SDPhotoBrowser.h"
@interface THDataImagesCell()<SDPhotoBrowserDelegate>
@property (strong, nonatomic) UILabel       *title;
@property (nonatomic, strong) UIScrollView   *scroll;
@property (nonatomic, strong) THDataM        *cellModel;
@end
@implementation THDataImagesCell
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
    [self.contentView addSubview:self.scroll];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.right.equalTo(self.contentView).offset(-8.0);
        make.top.equalTo(self.contentView).offset(13.0);
        make.height.greaterThanOrEqualTo(@(18.0));
    }];
    [self.scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.right.equalTo(self.contentView).offset(-8.0);
        make.top.equalTo(self.title.mas_bottom).offset(8.0);
        make.bottom.equalTo(self.contentView).offset(-10.0);
        make.height.equalTo(@(70.0));
    }];
}

- (void)configCellModel:(THDataM *)model{
    if(model.cellType != 3){
        return;
    }
    _cellModel = model;
    self.title.text = model.title;
    
    for (UIImageView *view in self.scroll.subviews) {
        if([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
    
    int i = 0;
    for (NSString *imgUrl in model.imgUrls) {
        UIImageView *view = [[UIImageView alloc]init];
        view.frame = CGRectMake(i*(70+7), 0, 70, 70);
        view.tag = (i+1);
        view.userInteractionEnabled = YES;
        [view sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
        //单击手势
        UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [view addGestureRecognizer:tapRecognize];

        [self.scroll addSubview:view];
        i++;
    }
    self.scroll.contentSize = CGSizeMake(i*77, 70);
}

-(void) handleTap:(UITapGestureRecognizer *)recognizer{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = recognizer.view.tag-1;
    photoBrowser.imageCount = _cellModel.imgUrls.count;
    photoBrowser.sourceImagesContainerView = self.scroll;
    [photoBrowser show];
}

- (UILabel *)title{
    if(!_title){
        _title = [[UILabel alloc]init];
        _title.font = [UIFont systemFontOfSize:14];
    }
    return _title;
}

- (UIScrollView *)scroll{
    if(!_scroll){
        _scroll = [[UIScrollView alloc]init];
    }
    return _scroll;
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIImageView *view = [self.scroll viewWithTag:index+1];
    return view.image;
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = [self.cellModel.imgUrls objectAtIndex:index];
    return [NSURL URLWithString:urlStr];
}


@end
