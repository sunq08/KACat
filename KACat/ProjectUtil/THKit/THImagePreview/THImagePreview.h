//
//  THImagePreview.h
//  GYSA
//
//  Created by SunQ on 2019/8/30.
//  Copyright © 2019年 itonghui. All rights reserved.
//  图片展示scroll view，只负责展示，不负责选择图片/上传图片，基于MJPhotoBrowser，sdwebimage

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum THImagePreviewStyle {
    THImageStylePreview       = 0,        //预览模式，没有删除按钮，没有添加按钮
    THImageStyleEdit          = 1,        //编辑模式，有添加按钮，可以添加图片进去，有删除按钮，可以删除
    THImageStylePlain         = 2,        //简介模式，没有添加按钮只能另外放置调用添加事件，有删除按钮
}THImagePreviewStyle;
@interface THImagePreview : UIScrollView
- (instancetype)initWithFrame:(CGRect)frame style:(THImagePreviewStyle)style;
/** 类型*/
@property (nonatomic ,assign) IBInspectable THImagePreviewStyle style;
/**更新数据源，images存储图片的网络地址，ids存储图片的标识信息*/
- (void)updateImagesWith:(NSMutableArray *)images ids:(NSMutableArray *)ids;
/**动态添加数据源，图片的网络地址，标识信息*/
- (void)addImageWith:(NSString *)url identifier:(NSString *)identifier;
/** 获取所有图片的标识信息（fileId）*/
- (NSMutableArray *)getImagesIdentifierData;
/** 重置*/
- (void)reset;
/** 点击添加按钮的回调，注意弱引用*/
@property (nonatomic,   copy) void (^imageAddClick)(NSInteger imageCount);

@property (nonatomic,   copy) void (^imageChanged)(NSMutableArray *fileIds);
@end

NS_ASSUME_NONNULL_END
