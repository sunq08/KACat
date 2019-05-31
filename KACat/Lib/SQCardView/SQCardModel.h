//
//  SQCardModel.h
//  EasyAccount
//
//  Created by SunQ on 2018/9/28.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SQCardModel : NSObject

@property (nonatomic,assign) BOOL       selected;
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *value;
@property (nonatomic,assign) float      width;

@end
