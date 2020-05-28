//
//  THCardLabel.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum THCardLabelStyle {
    THCardLabelRadio      = 0,        //单选
    THCardLabelCheckBox   = 1,        //多选
}THCardLabelStyle;

@class THCardLabel;
@protocol THCardLabelDelegate <NSObject>
- (void)thCardLabelTouchUpInside:(THCardLabel *)sender;
@end
@interface THCardLabel : UIButton
+ (instancetype)creatLabelWith:(THCardLabelStyle)style;
@property (nonatomic,strong) NSString *val;
@property (nonatomic,strong) NSString *text;
/** 代理*/
@property (nonatomic, assign) id<THCardLabelDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
