//
//  ClassAddViewController.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassM;
@interface ClassAddViewController : UIViewController

@property (nonatomic,assign) NSInteger  p_class_id; //父class id
@property (nonatomic,strong) ClassM     *classM;    //修改的class

@end
