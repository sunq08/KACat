//
//  THImagePreview.m
//  GYSA
//
//  Created by SunQ on 2019/8/30.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THImagePreview.h"
#import "THKitConfig.h"
#import "SDPhotoBrowser.h"
@interface THImageItem : UIView
@property (nonatomic, strong) UIImageView *mainImg;
@property (nonatomic, strong) UIButton *delbutton;
@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic,   copy) NSString *identifier;
@property (nonatomic, assign) int index;
@property (nonatomic,   copy) void(^deleteImageBlock)(int imageIndex);
@property (nonatomic,   copy) void(^tapImageBlock)(int imageIndex);
@end
@implementation THImageItem
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    
    self.mainImg = [[UIImageView alloc]init];
    self.mainImg.frame = CGRectMake(0, 0, width, height);
    [self addSubview:self.mainImg];
    
    UIButton *mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.frame = CGRectMake(0, 0, width, height);
    [mainBtn addTarget:self action:@selector(tapIconView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mainBtn];
    
    _delbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _delbutton.frame = CGRectMake(width-21, 0, 21, 21);
    [_delbutton setImage:[UIImage imageNamed:@"th-base-del"] forState:UIControlStateNormal];
    [_delbutton addTarget:self action:@selector(deleteImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_delbutton];
}
- (void)tapIconView{
    if(self.tapImageBlock) self.tapImageBlock(self.index);
}
- (void)deleteImageClick{
    if(self.deleteImageBlock) self.deleteImageBlock(self.index);
}
- (void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}
@end


@interface THImagePreview()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, assign) int imageCount;
@end
@implementation THImagePreview
- (instancetype)initWithFrame:(CGRect)frame style:(THImagePreviewStyle)style{
    self = [super initWithFrame:frame];
    if (self) {
        self.style = style;
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    self.images = [NSMutableArray arrayWithCapacity:0];
}

- (void)addClick:(UIButton *)sender{
    if(self.imageAddClick && self.style == THImageStyleEdit){
        NSInteger count = [self getImagesIdentifierData].count;
        self.imageAddClick(count);
    }
}

- (void)setStyle:(THImagePreviewStyle)style{
    _style = style;
    
    if(style == THImageStyleEdit){
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addButton];
        float height = self.frame.size.height;
        self.addButton.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton.titleLabel setFont:[UIFont systemFontOfSize:24]];
        self.addButton.frame = CGRectMake(0, 0, height, height);
    }
}

#pragma mark - insert image
- (void)updateImagesWith:(NSMutableArray *)images ids:(NSMutableArray *)ids{
    [self.images removeAllObjects];
    
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]]){
            [view removeFromSuperview];
        }
    }
    [self.images addObjectsFromArray:images];
    
    if(self.images.count == 0){
        return;
    }
    float height = self.frame.size.height;
    int i = 0;
    for (NSString *urlStr in self.images) {
        CGRect rect = CGRectMake(i*(height+8), 0, height, height);
        THImageItem *upload = [self creatItemWith:urlStr index:i frame:rect];
        upload.identifier = [ids objectAtIndex:i];
        [self addSubview:upload];
        
        i ++;
    }
    _imageCount = i;
    
    if(self.style == THImageStyleEdit){
        self.addButton.frame = CGRectMake(i*(height+8)+8, 0, height, height);
        [self setContentSize:CGSizeMake((i+1)*(height+8), height)];
    }else [self setContentSize:CGSizeMake(i*(height+8), height)];
    
    if(self.imageChanged){
        self.imageChanged([self getImagesIdentifierData]);
    }
}

- (void)addImageWith:(NSString *)url identifier:(NSString *)identifier{
    [self.images addObject:url];
    float height = self.frame.size.height;
    CGRect rect = CGRectMake(_imageCount*(height+8)+8, 0, height, height);
    THImageItem *upload = [self creatItemWith:url index:_imageCount frame:rect];
    upload.identifier = identifier;
    [self addSubview:upload];
    
    _imageCount++;
    
    if(self.style == THImageStyleEdit){
        self.addButton.frame = CGRectMake(_imageCount*(height+8)+8, 0, height, height);
        [self setContentSize:CGSizeMake((_imageCount+1)*(height+8), height)];
    }else [self setContentSize:CGSizeMake(_imageCount*(height+8), height)];
    
    if(self.imageChanged){
        self.imageChanged([self getImagesIdentifierData]);
    }
}

- (void)removeImageWith:(int)index{
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]] && view.index == index){
            [view removeFromSuperview];
        }
    }
    
    //重新编序号，防止后面删除序号错乱
    float height = self.frame.size.height;
    int i = 0;
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]]){
            view.index = i;
            view.frame = CGRectMake(i*(height+8), 0, height, height);
            i++;
        }
    }
    _imageCount = i;
    
    if(self.style == THImageStyleEdit){
        self.addButton.frame = CGRectMake(_imageCount*(height+8)+8, 0, height, height);
    }
    
    if(self.imageChanged){
        self.imageChanged([self getImagesIdentifierData]);
    }
}

- (void)reset{
    [self.images removeAllObjects];
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]]){
            [view removeFromSuperview];
        }
    }
    self.imageCount = 0;
    
    if(self.imageChanged){
        self.imageChanged([self getImagesIdentifierData]);
    }
}

#pragma mark - get data
- (NSMutableArray *)getImagesIdentifierData{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:0];
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]]){
            [datas addObject:view.identifier];
        }
    }
    return datas;
}

- (THImageItem *)creatItemWith:(NSString *)url index:(int)index frame:(CGRect)frame{
    THImageItem *upload = [[THImageItem alloc]initWithFrame:frame];
    upload.urlStr = url;
    upload.index = index;
    
    __weak typeof(self) weakSelf = self;
    upload.tapImageBlock = ^(int imageIndex) {
        [weakSelf showBrowserWithTag:imageIndex];
    };
    if(self.style == THImageStylePreview){
        upload.delbutton.hidden = YES;
    }else{
        upload.deleteImageBlock = ^(int imageIndex) {
            [weakSelf removeImageWith:imageIndex];
        };
    }
    
    return upload;
}

#pragma mark - photoBrowser
- (void)showBrowserWithTag:(int)tag{
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = tag;
    photoBrowser.imageCount = self.imageCount;
    photoBrowser.sourceImagesContainerView = self;
    [photoBrowser show];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    THImageItem *result;
    for (THImageItem *view in self.subviews) {
        if([view isKindOfClass:[THImageItem class]]){
            if(view.index == index){
                result = view;
                break;
            }
        }
    }
    return result?result.mainImg.image:[UIImage imageNamed:@""];
}

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *urlStr = [self.images objectAtIndex:index];
    return [NSURL URLWithString:urlStr];
}

@end
