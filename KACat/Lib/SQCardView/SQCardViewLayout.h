//
//  SQCardViewLayout.h
//  EasyAccount
//
//  Created by SunQ on 2018/9/29.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SQCardViewLayout;

@protocol  SQCardViewLayoutDeleaget<NSObject>
@required

- (CGSize)cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
/** 头视图Size */
-(CGSize )cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForFooterViewInSection:(NSInteger)section;
@optional

@end

@interface SQCardViewLayout : UICollectionViewLayout
/** 代理 */
@property (nonatomic, weak) id<SQCardViewLayoutDeleaget> delegate;

@end
