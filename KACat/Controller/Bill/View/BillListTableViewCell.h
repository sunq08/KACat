//
//  BillListTableViewCell.h
//  EasyAccount
//
//  Created by SunQ on 2018/8/17.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *class_name;
@property (weak, nonatomic) IBOutlet UILabel *type_name;
@property (weak, nonatomic) IBOutlet UILabel *add_time;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
