//
//  BillAddViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "BillAddViewController.h"
#import "SelectClassViewController.h"
#import "HYCalendarView.h"

#import "BillM.h"
#import "ClassM.h"
#import "AccountM.h"

#import "UITextFieldPicker.h"
#import "FSTextView.h"

@interface BillAddViewController ()

@property (nonatomic, weak) UISegmentedControl *segment;

@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *classNameTF;
@property (weak, nonatomic) IBOutlet UITextFieldPicker *accountNameTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet FSTextView *remarkTV;

@property (assign, nonatomic) BOOL isAdd;

@end

@implementation BillAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI{
    UISegmentedControl*segment = [[UISegmentedControl alloc]initWithItems:@[@"支出",@"收入"]];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(0, 0, 120, 30);
    [segment addTarget:self action:@selector(selectBillType:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    self.segment = segment;
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc]initWithImage:ImageNamed(@"icon_gou") style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    
    self.timeTF.text = [NSDate currentTimeWithFormat:DateFormatD];
}

- (void)loadData{
    NSArray *accounts = [[DataBase sharedDataBase] getAllAccountM];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    for (AccountM *model in accounts) {
        [dict setObject:model.name forKey:[NSString stringWithFormat:@"%ld",model.pkid]];
    }
    [self.accountNameTF setPickerData:dict];
    
    [self.accountNameTF setVal:[dict allKeys][0]];
    
    if(!self.billM){
        self.billM = [[BillM alloc]init];
        self.isAdd = YES;
    }else{
        self.amountTF.text = [NSString stringWithFormat:@"%.2f",self.billM.amount];
        self.classNameTF.text = self.billM.class_name;
        [self.accountNameTF setVal:[NSString stringWithFormat:@"%ld",self.billM.account_id]];
        self.timeTF.text = [NSDate dateToString:self.billM.time withDateFormat:DateFormatD];
        self.remarkTV.text = self.billM.remark;
    }
}

- (void)selectBillType:(UISegmentedControl *)segment{
    self.billM.class_id = 0;
    self.billM.class_name = @"";
}

- (IBAction)selectClassClick:(id)sender {
    SelectClassViewController *vc = [[SelectClassViewController alloc]init];
    vc.type = self.segment.selectedSegmentIndex;
    vc.refreshBlock = ^(NSInteger class_id, NSString *class_name) {
        self.billM.class_name = class_name;
        self.billM.class_id = class_id;
        self.classNameTF.text = class_name;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)selectTime:(UIButton *)sender {
    HYCalendarView *view = [[HYCalendarView alloc]initWithFrame:CGRectMake(0, 0, MScreenWidth, MScreenHeight)];
    view.itemType = HYCalendarItemTypeSquartCollected;
    view.chooseType = HYCalendarChooseSingle;
    view.resetImg = ImageNamed(@"icon_reset");
    WeakSelf;
    view.getTime = ^(NSString * firstDay, NSString * lastDay){
        if(ValidStr(firstDay))  weakSelf.timeTF.text = firstDay;
    };
    [view show];
}

- (void)saveClick{
    if(!ValidStr(self.amountTF.text)){
        [HUDManager showWarning:@"请输入数量"];
        return;
    }
    if(!ValidStr(self.billM.class_name)){
        [HUDManager showWarning:@"请选择分类"];
        return;
    }
    
    self.billM.amount = [self.amountTF.text doubleValue];
    self.billM.account = self.accountNameTF.text;
    self.billM.account_id = [self.accountNameTF.val integerValue];
    self.billM.remark = self.remarkTV.text;
    
    self.billM.time = [NSDate timeToDate:self.timeTF.text withDateFormat:DateFormatD];
    
    NSString *current = [NSDate currentTimeWithFormat:DateFormatD];
    self.billM.add_time = [NSDate timeToDate:current withDateFormat:DateFormatD];
    self.billM.oper_time = [NSDate timeToDate:current withDateFormat:DateFormatD];
    self.billM.type = self.segment.selectedSegmentIndex;
    
    if(self.isAdd){
        [[DataBase sharedDataBase] addBillM:self.billM];
    }else{
        [[DataBase sharedDataBase] updateBillM:self.billM];
    }
    
    if(self.refreshBlock) self.refreshBlock();
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_HomeReload object:nil userInfo:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
