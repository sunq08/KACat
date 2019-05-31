//
//  SQCardView.m
//  EasyAccount
//
//  Created by SunQ on 2018/9/28.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "SQCardView.h"
#import "SQCardModel.h"
#import "SQCardViewLayout.h"

#define SQCARDW       self.frame.size.width
#define SQCARDH       self.frame.size.height

@interface SQCardCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *textLabel;

@end

@implementation SQCardCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor    = [UIColor whiteColor];
        self.textLabel                      = [[UILabel alloc] init];
        self.textLabel.textAlignment        = NSTextAlignmentCenter;
        self.textLabel.font                 = [UIFont systemFontOfSize:14];
        self.textLabel.textColor            = [UIColor darkGrayColor];
        [self.contentView addSubview:self.textLabel];
        
        [self.contentView.layer setCornerRadius:3];
        [self.contentView.layer setMasksToBounds:YES];
        [self.contentView.layer setBorderWidth:1];
        [self.contentView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        
        //约束
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.equalTo(self).with.offset(0);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker*make) {
            make.left.top.equalTo(self.contentView).with.offset(4);
            make.right.bottom.equalTo(self.contentView).offset(-4);
            make.width.mas_lessThanOrEqualTo([UIScreen mainScreen].bounds.size.width-20);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    UIColor *bgColor = (selected)?[UIColor redColor]:[UIColor whiteColor];
    UIColor *textColor = (selected)?[UIColor whiteColor]:[UIColor darkGrayColor];
    UIColor *bdColor = (selected)?[UIColor redColor]:[UIColor lightGrayColor];
    [self.contentView.layer setBorderColor:[bdColor CGColor]];
    self.textLabel.textColor            = textColor;
    self.contentView.backgroundColor    = bgColor;
}

@end


static NSString * const SQCardCellID = @"SQCARDCELL";//cell的ide

@interface SQCardView()<UICollectionViewDataSource, UICollectionViewDelegate,SQCardViewLayoutDeleaget>

@property (nonatomic,strong) UICollectionView *mainCollection;

@property (nonatomic,strong) NSMutableArray *pageList;

@end

@implementation SQCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    
    //设置布局
    SQCardViewLayout * flowLayout   = [[SQCardViewLayout alloc] init];
    flowLayout.delegate = self;
    
    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SQCARDW, SQCARDH) collectionViewLayout:flowLayout];
    self.mainCollection.backgroundColor = [UIColor whiteColor];
    self.mainCollection.delegate        = self;
    self.mainCollection.dataSource      = self;
    [self addSubview:self.mainCollection];
    
    //注册
    [self.mainCollection registerClass:[SQCardCell class] forCellWithReuseIdentifier:SQCardCellID];
}

- (void)addDataWithList:(NSMutableArray *)array{
    [self.pageList addObjectsFromArray:array];
    [self.mainCollection reloadData];
}

#pragma mark  - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pageList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SQCardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SQCardCellID forIndexPath:indexPath];
    NSString *string = [self.pageList objectAtIndex:indexPath.row];
    cell.textLabel.text = string;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark  - CardViewLayoutDelegate
- (CGSize)cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [self.pageList objectAtIndex:indexPath.row];
    CGFloat width = [string widthWithFontSize:14 height:21] + 10;
    return CGSizeMake(width, 21);
}
/** 头视图Size */
-(CGSize )cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
/** 脚视图Size */
-(CGSize )cardFlowLayout:(SQCardViewLayout *)cardFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}

-(NSMutableArray *)pageList{
    if(!_pageList){
        _pageList = [NSMutableArray arrayWithCapacity:0];
    }
    return _pageList;
}
@end

#pragma mark  -
#pragma mark  - CardViewLayoutDelegate


