//
//  HomeHeadView.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/27.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HomeHeadViewBlock) (void);

@interface HomeHeadView : UIView

@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenditureLabel;

//点击刷新
@property (nonatomic,   copy) HomeHeadViewBlock   centerBlock;

@end
