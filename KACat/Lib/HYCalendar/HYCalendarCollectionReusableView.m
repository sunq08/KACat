//
//  HYCalendarCollectionReusableView.m
//  HYCalendar
//
//  Created by 王厚一 on 16/11/14.
//  Copyright © 2016年 why. All rights reserved.
//

#import "HYCalendarCollectionReusableView.h"

@implementation HYCalendarCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.timeLabel = [[UILabel alloc]init];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.timeLabel];
        
        float width = frame.size.width;
        float height = frame.size.height;
        self.timeLabel.frame = CGRectMake(0, 0, width, height-1);
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)showTimeLabelWithArray:(NSArray *)array {
    self.timeLabel.text = [NSString stringWithFormat:@"%@年%@月", array[0], array[1]];
}

@end
