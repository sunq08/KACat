//
//  THSortView.h
//  GYSA
//
//  Created by SunQ on 2019/8/29.
//  Copyright © 2019年 itonghui. All rights reserved.
//  通用排序视图，对于同一个项目来说，排序视图风格应当是统一一致的

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THSortItem : UIButton
@property (nonatomic,   copy) NSString *identifier;
@property (nonatomic,   copy) NSString *senderTitle;
@end

/** 目前只支持点击单种排序方式，暂不支持反向排序*/
@class THSortView;
@protocol THSortViewDelegate <NSObject>
@required
/** 使用键（identifier）值（标题）对的方式进行初始化*/
- (NSMutableArray <NSDictionary *>*)titlesWithSortView:(THSortView *)sortView;
@optional
- (void)sortView:(THSortView *)sortView didSelectItemWithId:(NSString *)identifier;

- (void)sortViewDidSelectScreen:(THSortView *)sortView;
@end
@interface THSortView : UIView
@property (nonatomic, assign) id<THSortViewDelegate> delegate;
/** 默认选中*/
@property (nonatomic, strong) NSNumber *defaultSelectIndex;

@property (nonatomic, assign) BOOL      showScreen;//展示筛选按钮
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
