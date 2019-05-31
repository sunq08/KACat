//
//  HYCalendarView.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/22.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#define HYSCREENW       self.frame.size.width
#define HYSCREENH       self.frame.size.height
#define HYMainViewH     HYSCREENH-200
#define DefultC         [UIColor colorWithRed:0/255.0 green:200/255.0 blue:177/255.0 alpha:1.0]

#import "HYCalendarView.h"

static NSString * const calendarCell    = @"CalendarCell";  //cell的ide
static NSString * const calendarHeader  = @"CalendarHeader";//header的ide
static NSString * const calendarFooter  = @"CalendarFooter";//header的ide
@interface HYCalendarView()<UICollectionViewDataSource, UICollectionViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) UIView            *mainView;

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic,   weak) UIButton          *resetBtn;
@property (nonatomic,   weak) UIButton          *doneBtn;

@property (nonatomic, strong) NSDate            *nowDate;       //当前的时间
@property (nonatomic, strong) NSTimeZone        *timeZone;      //当地时区
@property (nonatomic, strong) NSCalendar        *calendar;      //当前日历
@property (nonatomic, strong) NSDateComponents  *components;    //当前日期的零件
@property (nonatomic, strong) NSDateFormatter   *formatter;     //时间书写格式
@property (nonatomic, strong) NSArray           *weekdays;      //日历星期格式

@end
@implementation HYCalendarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.mainView                   = [[UIView alloc]init];
    self.mainView.frame             = CGRectMake(0, 200, HYSCREENW, HYMainViewH);
    self.mainView.backgroundColor   = [UIColor whiteColor];
    [self addSubview:self.mainView];
    
    UILabel *title                  = [self creatTitleLabel:@"选择日期"];
    title.frame                     = CGRectMake(0, 0, HYSCREENW, 44);
    [self.mainView addSubview:title];
    
    UILabel *line                   = [[UILabel alloc]init];
    line.frame                      = CGRectMake(0, title.bottom, HYSCREENW, 1);
    line.backgroundColor            = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:line];
    
    NSArray *array                  = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    float labW                      = SCREEN_W/array.count;
    for (int i = 0; i < array.count; i ++ ) {
        UILabel *lab                = [self creatTitleLabel:array[i]];
        lab.frame                   = CGRectMake(i*labW, line.bottom, labW, 36);
        [self.mainView addSubview:lab];
    }
    
    self.nowDate = [NSDate date];
    
    //设置布局
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize                     = CGSizeMake(HYSCREENW / 7.0, 50);//item大小
    flowLayout.scrollDirection              = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.headerReferenceSize          = CGSizeMake(HYSCREENW, 30);//header大小
    flowLayout.footerReferenceSize          = CGSizeMake(HYSCREENW, 0);//footer大小
    flowLayout.minimumLineSpacing           = 0;
    flowLayout.minimumInteritemSpacing      = 0;
    flowLayout.sectionInset                 = UIEdgeInsetsMake(0, 0, 0, 0);//边界距离
    flowLayout.sectionHeadersPinToVisibleBounds = YES;
    flowLayout.sectionFootersPinToVisibleBounds = YES;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, line.bottom + 36, HYSCREENW, self.mainView.frame.size.height - line.bottom - 36 - 57) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册
    [_collectionView registerClass:[HYCalendarCollectionViewCell class] forCellWithReuseIdentifier:calendarCell];
    [_collectionView registerClass:[HYCalendarCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:calendarHeader];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:calendarFooter];
    
    [self.mainView addSubview:_collectionView];
    
    UILabel *lineB = [[UILabel alloc]initWithFrame:CGRectMake(0, _collectionView.bottom, HYSCREENW, 1)];
    lineB.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.mainView addSubview:lineB];
    
    UIButton *sure              = [UIButton buttonWithType:UIButtonTypeCustom];
    sure.backgroundColor        = DefultC;
    sure.frame                  = CGRectMake(30, lineB.bottom + 8, HYSCREENW-60, 40);
    sure.layer.masksToBounds    = YES;
    sure.layer.cornerRadius     = 5;
    [sure setTitle:@"完成" forState:UIControlStateNormal];
    [sure addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:sure];
    self.doneBtn                = sure;
    
    UIButton *reset             = [UIButton buttonWithType:UIButtonTypeCustom];
    reset.frame                 = CGRectMake(HYSCREENW-75, 7, 60, 30);
    reset.titleLabel.font       = [UIFont systemFontOfSize:14];
    [reset setTitle:@"重置" forState:UIControlStateNormal];
    [reset setTitleColor:DefultC forState:UIControlStateNormal];
    [reset addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    [self.mainView addSubview:reset];
    self.resetBtn               = reset;
}

#pragma mark - ------------获取时间方法-------------

/**根据当前时间获取当前和以后各有多少个月，0为当前月*/
- (NSDate *)getEarlierAndLaterDaysFromDate:(NSDate *)date withMonth:(NSInteger)month {
    NSDate * newDate = [NSDate date];
    NSDateComponents * components = [self getCurrentComponentWithDate:newDate];
    //获取section表示的每个月份
    NSInteger year = [components year];
    NSInteger month_n = [components month];
    //希望从哪年开始写日历 例如2016年
    NSInteger month_count = (year - 2018) * 12;
    //获取当前section代表的月份和现在月份的差值
    NSInteger months = month - month_count - month_n + 1;
    [self.components setMonth:months];
    //返回各月份的当前日期，如：2016-01-14，2016-02-14
    NSDate * ndate = [self.calendar dateByAddingComponents:self.components toDate:date options:0];
    
    return ndate;
}

/**获取每个单位内开始时间*/
- (NSString *)getBeginTimeInMonth:(NSDate *)date {
    
    NSTimeInterval count = 0;
    NSDate * beginDate = nil;
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //返回日历每个月份的开始时间，类型是unitMonth
    BOOL findFirstTime = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&count forDate:date];
    
    if (findFirstTime) {
        
        //日历设置为当前时区
        [self.calendar setTimeZone:self.timeZone];
        
        //标识为星期
        NSCalendarUnit unitFlags = NSCalendarUnitWeekday;
        
        //返回每个月第一天是周几
        NSDateComponents * com = [self.calendar components:unitFlags fromDate:beginDate];
        
        //更换为新的星期格式
        NSString * weekday = [self.weekdays objectAtIndex:[com weekday]];
        
        return weekday;
    }else {
        return @"";
    }
    
}

/**获取每个月多少天*/
- (NSInteger)getTotalDaysInMonth:(NSDate *)date {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    
    //标识为day的单位在标识为month的单位中的格式，返回range
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    return range.length;
}

/**获取当前日期格式*/
- (NSArray *)getTimeFormatArrayWithDate:(NSDate *)date andMonth:(NSInteger)month {
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:month];
    NSString * stringFormat = [self.formatter stringFromDate:dateTime];
    //通过“-”拆分日期格式
    return [stringFormat componentsSeparatedByString:@"-"];
}

/**获取当前日期零件*/
- (NSDateComponents *)getCurrentComponentWithDate:(NSDate *)dateTime {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    //日期拆分类型
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    return [calendar components:unitFlags fromDate:dateTime];
}

#pragma mark - ------------ DataSource && Delegate -------------

// section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 100;
}

// item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:section];
    NSString * firstTime = [self getBeginTimeInMonth:dateTime];
    NSInteger startDay = [firstTime integerValue];//开始时间，同样表示这个月开始前几天是空白
    NSInteger totalDays = [self getTotalDaysInMonth:dateTime];//某个月总天数
    
    return startDay + totalDays;
}

// cell代理方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:calendarCell forIndexPath:indexPath];
    
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
    //1号以前的负数日期不用显示
    NSInteger dayIndex = indexPath.row - [self getBeginTimeInMonth:dateTime].integerValue + 1;
    NSString * dayString = dayIndex > 0 ? [NSString stringWithFormat:@"%ld", dayIndex] : @"";
    NSDateComponents * components = [self getCurrentComponentWithDate:dateTime];
    
    cell.day.text = dayString;
    cell.type = (self.itemType)?self.itemType:HYCalendarItemTypeSquartCollected;
    [cell reloadCellWithFirstDay:self.firstDay andLastDay:self.lastDay andCurrentDay:@[[NSNumber numberWithInteger:[components year]], [NSNumber numberWithInteger:[components month]], [NSNumber numberWithInteger:dayIndex]]];
    
    return cell;
}

// 点击代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate * dateTime = [self getEarlierAndLaterDaysFromDate:self.nowDate withMonth:indexPath.section];
    NSInteger dayIndex = indexPath.row - [self getBeginTimeInMonth:dateTime].integerValue + 1;
    NSDateComponents * components = [self getCurrentComponentWithDate:dateTime];
    
    //判断选择类型，单个类型选中后直接返回，否则选中两次返回
    if (self.chooseType == HYCalendarChooseSingle) {
        //年份和月份是通过section查找到，天数是通过row查到
        self.firstDay = @[[NSNumber numberWithInteger:[components year]],[NSNumber numberWithInteger:[components month]],[NSNumber numberWithInteger:dayIndex]];
        //由于单个选择直接刷新列表并返回
        [self.collectionView reloadData];
    }
    
    if (self.chooseType == HYCalendarChooseDouble || !self.chooseType) {
        //由于上次选择时间有保留所以可能造成两个时间数组都有数据，如果可以点击并且后一个数组有数据说明是上次预留，清空数据。
        if (self.lastDay.count != 0) {
            self.firstDay = nil;
            self.lastDay = nil;
        }
        
        //只选择一项时值只刷新列表，全部选择时刷新并返回
        if (self.firstDay.count == 0) {
            self.firstDay = @[[NSNumber numberWithInteger:[components year]],[NSNumber numberWithInteger:[components month]],[NSNumber numberWithInteger:dayIndex]];
            [self.collectionView reloadData];
        }else {
            NSInteger firstYear = [self.firstDay[0] integerValue];
            NSInteger firstMonth = [self.firstDay[1] integerValue];
            NSInteger firstDay = [self.firstDay[2] integerValue];
            BOOL isMax = YES;//默认第二次选的大
            if(firstYear > [components year]){
                isMax = NO;
            }else if(firstYear == [components year]){
                if(firstMonth > [components month]){
                    isMax = NO;
                }else if(firstMonth == [components month]){
                    if(firstDay > dayIndex){
                        isMax = NO;
                    }
                }
            }
            if(!isMax){//第二次选的比第一次小,清空第一次的，重新选
                self.firstDay = @[[NSNumber numberWithInteger:[components year]],[NSNumber numberWithInteger:[components month]],[NSNumber numberWithInteger:dayIndex]];
                [self.collectionView reloadData];
            }else{//第二次选的比第一次大，正常设置
                self.lastDay = @[[NSNumber numberWithInteger:[components year]],[NSNumber numberWithInteger:[components month]],[NSNumber numberWithInteger:dayIndex]];
                [self.collectionView reloadData];
            }
        }
    }
}

// header代理方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        HYCalendarCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:calendarHeader forIndexPath:indexPath];
        
        //设置headerView的title
        [headerView showTimeLabelWithArray:(NSArray *)[self getTimeFormatArrayWithDate:self.nowDate andMonth:indexPath.section]];
        
        
        return headerView;
        
    }
    UICollectionReusableView *footerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:calendarFooter forIndexPath:indexPath];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return footerView;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"---%.2f",scrollView.mj_offsetY);
}

#pragma mark - -----------lazy load-------------

- (NSTimeZone *)timeZone {
    //时区为中国上海
    if (!_timeZone) {
        _timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    }
    return _timeZone;
}

- (NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _calendar;
}

- (NSDateComponents *)components {
    if (!_components) {
        _components = [[NSDateComponents alloc] init];
    }
    return _components;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (NSArray *)weekdays {
    //苹果日历每周第一天是周一，修改日历格式
    if (!_weekdays) {
        _weekdays = @[[NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6"];
    }
    return _weekdays;
}
#pragma mark - -----------------setter-----------------
- (void)setResetImg:(UIImage *)resetImg{
    _resetImg = resetImg;
    
    [self.resetBtn setTitle:@"" forState:UIControlStateNormal];
    [self.resetBtn setImage:resetImg forState:UIControlStateNormal];
}

- (void)setMainC:(UIColor *)mainC{
    _mainC = mainC;
    
    self.doneBtn.backgroundColor = mainC;
    [self.resetBtn setTitleColor:mainC forState:UIControlStateNormal];
}


#pragma mark - -----------------其他方法-----------------
- (UILabel *)creatTitleLabel:(NSString *)text{
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:15];
    return label;
}

- (void)resetClick{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month1 = [dateComponent month];
    //    NSInteger day = [dateComponent day];
    
    NSInteger months = (year - 2018) * 12 + month1 - 1;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:months] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    CGPoint point = self.collectionView.contentOffset;
    point.y -= 30;
    self.collectionView.contentOffset = point;
}


- (void)sureClick{
    //将两个时间返回
    if (self.getTime) {
        NSString *start = (self.firstDay && self.firstDay.count>0)?[NSString stringWithFormat:@"%ld-%02ld-%02ld",[self.firstDay[0] integerValue],[self.firstDay[1] integerValue],[self.firstDay[2] integerValue]]:nil;
        NSString *end = (self.lastDay && self.lastDay.count>0)?[NSString stringWithFormat:@"%ld-%02ld-%02ld",[self.lastDay[0] integerValue],[self.lastDay[1] integerValue],[self.lastDay[2] integerValue]]:nil;
        self.getTime(start, end);
    }
    
    //延迟执行以下SEL中方法
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.2];
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.mainView.y = HYSCREENH;
    self.backgroundColor = rgbA(0, 0, 0, 0);
    [UIView animateWithDuration:.2 animations:^{
        self.mainView.y = 200;
        self.backgroundColor = rgbA(0, 0, 0, 0.4);
    }];
    
    [self resetClick];
}

- (void)dismiss{
    [UIView animateWithDuration:.2 animations:^{
        self.backgroundColor = rgbA(0, 0, 0, 0);
        self.mainView.y = HYSCREENH;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint pt = [touch locationInView:self];
    if (!CGRectContainsPoint([self.mainView frame], pt)) {
        [self dismiss];
    }
}

@end
