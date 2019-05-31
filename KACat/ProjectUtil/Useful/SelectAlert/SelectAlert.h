//
//  SelectAlert.h
//  SelectAlertDemo
//
//  Created by apple on 2016/11/24.
//  Copyright © 2016年 周兴. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectIndex)(NSInteger selectIndex);//编码
typedef void (^SelectValue)(NSString *selectValue);//数值


@interface SelectAlert : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *titles;//string数组

@property (nonatomic, strong) UILabel *titleLabel;//标题label
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮

@property (nonatomic, copy) SelectIndex selectIndex;
@property (nonatomic, copy) SelectValue selectValue;

/*!
 * @abstract 创建弹窗下拉列表类方法
 *
 * @param title 下拉框标题
 * @param titles 下拉框显示的string数组
 * @param selectIndex 选择的index
 * @param selectValue 选择的string
 * @param showCloseButton 显示关闭按钮则关闭点击列表外remove弹窗的功能
 *
 */
+ (SelectAlert *)showWithTitle:(NSString *)title
                        titles:(NSArray *)titles
                   selectIndex:(SelectIndex)selectIndex
                   selectValue:(SelectValue)selectValue
               showCloseButton:(BOOL)showCloseButton;

@end
