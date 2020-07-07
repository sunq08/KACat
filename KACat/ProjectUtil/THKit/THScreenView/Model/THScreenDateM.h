//
//  THScreenDateM.h
//  GYSA
//
//  Created by SunQ on 2019/10/14.
//  Copyright © 2019年 itonghui. All rights reserved.
//

#import "THScreenBaseM.h"

NS_ASSUME_NONNULL_BEGIN

@interface THScreenDateM : THScreenBaseM
@property (nonatomic, assign) BOOL      openRange;
@property (nonatomic,   copy) NSString  *format;//默认 YYYY-MM-DD HH:mm:ss
@end

NS_ASSUME_NONNULL_END
