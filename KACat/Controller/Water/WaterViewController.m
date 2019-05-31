//
//  WaterViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/6.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "WaterViewController.h"
#import "ZFChart.h"
@interface WaterViewController ()<ZFGenericChartDataSource, ZFLineChartDelegate>

@property (nonatomic, strong) ZFLineChart * lineChart;

@end

@implementation WaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI{
    self.title = @"流水";
    self.view.backgroundColor = MTableBgColor;
    CGFloat height = 300;
    
    self.lineChart = [[ZFLineChart alloc] initWithFrame:CGRectMake(0, TopHeight + 15, SCREEN_WIDTH, height)];
    self.lineChart.dataSource = self;
    self.lineChart.delegate = self;
    self.lineChart.topicLabel.hidden = YES;
    self.lineChart.unit = @"人";
    self.lineChart.topicLabel.textColor = ZFPurple;
    self.lineChart.isShowXLineSeparate = YES;
    self.lineChart.isShowYLineSeparate = YES;
    self.lineChart.valueCenterToCircleCenterPadding = 20.0;
    self.lineChart.isShowAxisLineValue = NO;
    
    [self.view addSubview:self.lineChart];
    [self.lineChart strokePath];
}

- (void)loadData{
    
}

#pragma mark - ZFGenericChartDataSource
//value
- (NSArray *)valueArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"123", @"256", @"20", @"350", @"490", @"236",
             @"123", @"256", @"50"];
}

//横坐标
- (NSArray *)nameArrayInGenericChart:(ZFGenericChart *)chart{
    return @[@"一年级", @"二年级", @"三年级", @"四年级", @"五年级", @"六年级",
             @"七年级", @"八年级", @"九年级"];
}

//圆点颜色数组
- (NSArray *)colorArrayInGenericChart:(ZFGenericChart *)chart{
    return @[ZFSkyBlue];
}

//最大值
- (CGFloat)axisLineMaxValueInGenericChart:(ZFGenericChart *)chart{
    return 500;
}

//偏移量
- (void)genericChartDidScroll:(UIScrollView *)scrollView{
    NSLog(@"当前偏移量 ------ %f", scrollView.contentOffset.x);
}

#pragma mark - ZFLineChartDelegate
- (CGFloat)groupWidthInLineChart:(ZFLineChart *)lineChart{
    return 45.f;
}

- (CGFloat)paddingForGroupsInLineChart:(ZFLineChart *)lineChart{
    return 0.0f;
}

//圆的半径(若不设置，默认为5.f)
- (CGFloat)circleRadiusInLineChart:(ZFLineChart *)lineChart{
    return 3.0f;
}

//线宽(若不设置，默认为2.f)
- (CGFloat)lineWidthInLineChart:(ZFLineChart *)lineChart{
    return 1.0f;
}

- (NSArray<ZFGradientAttribute *> *)gradientColorArrayInLineChart:(ZFLineChart *)lineChart{
    ZFGradientAttribute * gradientAttribute = [[ZFGradientAttribute alloc] init];
    gradientAttribute.colors = @[(id)ZFRed.CGColor, (id)ZFRed.CGColor];
    gradientAttribute.locations = @[@(0.1), @(0.22)];
    gradientAttribute.startPoint = CGPointMake(0.5, 0);
    gradientAttribute.endPoint = CGPointMake(0.5, 1);
    
    return [NSArray arrayWithObjects:gradientAttribute, nil];
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectCircleAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex circle:(ZFCircle *)circle popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个", (long)circleIndex);
    
    //可将isShowAxisLineValue设置为NO，然后执行下句代码进行点击才显示数值
    popoverLabel.hidden = NO;
}

- (void)lineChart:(ZFLineChart *)lineChart didSelectPopoverLabelAtLineIndex:(NSInteger)lineIndex circleIndex:(NSInteger)circleIndex popoverLabel:(ZFPopoverLabel *)popoverLabel{
    NSLog(@"第%ld个" ,(long)circleIndex);
    
//    //可在此处进行popoverLabel被点击后的自身部分属性设置
//    popoverLabel.textColor = ZFGold;
//    [popoverLabel strokePath];
}

@end
