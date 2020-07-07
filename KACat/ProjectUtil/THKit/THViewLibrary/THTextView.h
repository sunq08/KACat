//
//  THTextView.h
//  THKitProject
//
//  Created by 孙强 on 2020/6/1.
//  Copyright © 2020 sunq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface THTextView : UITextView
/* 便利构造器创建FSTextView实例*/
+ (instancetype)textView;
/* 最大限制文本长度, 默认为无穷大(即不限制)*/
@property (nonatomic, assign) IBInspectable NSUInteger limitLength;
/* placeholder, 会自适应TextView宽高以及横竖屏切换*/
@property (nonatomic,   copy) IBInspectable NSString *placeholder;
/* placeholder文本颜色*/
@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor;
@end

NS_ASSUME_NONNULL_END
