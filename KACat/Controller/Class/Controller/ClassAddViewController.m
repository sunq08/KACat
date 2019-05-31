//
//  ClassAddViewController.m
//  EasyAccount
//
//  Created by SunQ on 2018/8/15.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "ClassAddViewController.h"
#import "ClassM.h"
@interface ClassAddViewController ()
@property (weak, nonatomic) UITextField *nameTF;
@end

@implementation ClassAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI{
    NSString *title = (self.classM)?@"修改分类":@"新增分类";
    self.title = title;
    self.view.backgroundColor = MTableBgColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIView *nameView = [[UIView alloc]init];
    nameView.backgroundColor = MWhiteColor;
    [self.view addSubview:nameView];
    
    UILabel *nameLab = [[UILabel alloc]init];
    nameLab.text = @"分类名称";
    nameLab.font = SYSTEMFONT(15);
    nameLab.textColor = [UIColor hex:@"333333"];
    [nameView addSubview:nameLab];
    
    UITextField *nameTF = [[UITextField alloc]init];
    nameTF.textAlignment = NSTextAlignmentRight;
    nameTF.placeholder = @"名称";
    nameTF.font = SYSTEMFONT(14);
    [nameView addSubview:nameTF];
    self.nameTF = nameTF;
    if(self.classM) self.nameTF.text = self.classM.class_name;
    
    UIView *iconView = [[UIView alloc]init];
    iconView.backgroundColor = MWhiteColor;
    [self.view addSubview:iconView];
    
    UILabel *iconLab = [[UILabel alloc]init];
    iconLab.text = @"分类图标";
    iconLab.font = SYSTEMFONT(15);
    iconLab.textColor = [UIColor hex:@"333333"];
    [iconView addSubview:iconLab];
    
    UIImageView *arrow = [[UIImageView alloc]init];
    arrow.image = ImageNamed(@"icon_arrow");
    [iconView addSubview:arrow];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = ImageNamed(@"icon_upload");
    [iconView addSubview:icon];
    
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconBtn addTarget:self action:@selector(uploadClick) forControlEvents:UIControlEventTouchUpInside];
    [iconView addSubview:iconBtn];
    
    [nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.right.offset(0);
        make.height.offset(50);
    }];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.width.offset(72);
        make.left.offset(15);
    }];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(nameView);
        make.left.equalTo(nameLab.mas_right).offset(8);
        make.right.offset(-15);
    }];
    
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameView.mas_bottom).offset(1);
        make.left.right.offset(0);
        make.height.offset(50);
    }];
    [iconLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.width.offset(72);
        make.left.offset(15);
    }];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.height.width.offset(15);
        make.right.offset(-15);
    }];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.height.width.offset(30);
        make.right.equalTo(arrow.mas_left).offset(-4);
    }];
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make edges];
    }];
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [self.nameTF setValue:@10 forKey:@"LimitInput"];
    
    
    
}

- (void)saveClick{
    if(!ValidStr(self.nameTF.text)){
        [HUDManager showWarning:@"账户名称不能为空！"];
        return;
    }
    DataBase *db = [DataBase sharedDataBase];
    
    if(self.classM){//修改
        self.classM.class_name = self.nameTF.text;
        [db updateClassM:self.classM];
    }else{//新增
        ClassM *model = [[ClassM alloc] init];
        model.class_name = self.nameTF.text;
        
        int length = (self.p_class_id == 100)?6:9;
        NSString *sql = [NSString stringWithFormat:@"where class_id like '%ld%%%%' and length(class_id) = %d",self.p_class_id,length];
        
        NSArray *array = [db getClassMListWhere:sql];
        
        NSInteger max = self.p_class_id*1000+100;
        for (ClassM *item in array) {
            if (item.class_id > max) {
                max = item.class_id;
            }
        }
        model.class_id = max+1;
        [db addClassM:model];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadClick{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
