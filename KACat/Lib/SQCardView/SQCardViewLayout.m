//
//  SQCardViewLayout.m
//  EasyAccount
//
//  Created by SunQ on 2018/9/29.
//  Copyright © 2018年 itonghui. All rights reserved.
//

#import "SQCardViewLayout.h"
/** 每一列之间的间距*/
static const NSInteger CardDefaultColumeMargin = 10;
/** 每一行之间的间距*/
static const CGFloat CardDefaultRowMargin = 10;
/** 边缘之间的间距*/
static const UIEdgeInsets CardDefaultEdgeInset = {10, 10, 10, 10};

@interface SQCardViewLayout()

/** 存放所有cell的布局属性*/
@property (strong, nonatomic) NSMutableArray *attrsArray;
/** 存放每一列的最大y值*/
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 存放每一行的最大x值*/
@property (nonatomic, strong) NSMutableArray *rowWidths;
/** 内容的高度*/
@property (nonatomic, assign) CGFloat maxColumnHeight;
/** 每一行之间的间距*/
-(CGFloat)rowMargin;
/** 每一列之间的间距*/
-(CGFloat)columnMargin;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsets;
@end
@implementation SQCardViewLayout
#pragma mark item属性配置
-(CGFloat)columnMargin {
    return  CardDefaultColumeMargin;
}
-(CGFloat)rowMargin {
    return CardDefaultRowMargin;
}
-(UIEdgeInsets)edgeInsets {
    return  CardDefaultEdgeInset;
}

#pragma mark - 懒加载
- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
- (NSMutableArray *)rowWidths {
    if (!_rowWidths) {
        _rowWidths = [NSMutableArray array];
    }
    return _rowWidths;
}

-(NSMutableArray *)attrsArray {
    if (_attrsArray == nil) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - 重写系统方法
/** 初始化 生成每个视图的布局信息*/
-(void)prepareLayout {
    [super prepareLayout];
    
    //记录最后一个的内容的横坐标和纵坐标
    self.maxColumnHeight = 0;
    [self.columnHeights removeAllObjects];
    [self.columnHeights addObject:@(self.edgeInsets.top)];
    
    [self.rowWidths removeAllObjects];
    [self.rowWidths addObject:@(self.edgeInsets.left)];
    
    //清除之前数组
    [self.attrsArray removeAllObjects];
    
    //开始创建每一组cell的布局属性
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < sectionCount; section++){
        
        //获取每一组头视图header的UICollectionViewLayoutAttributes
        if([self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForHeaderViewInSection:)]){
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:headerAttrs];
        }
        
        //开始创建组内的每一个cell的布局属性
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++) {
            //创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            //获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attrs];
        }
        
        //获取每一组脚视图footer的UICollectionViewLayoutAttributes
        if([self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForFooterViewInSection:)]){
            UICollectionViewLayoutAttributes *footerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [self.attrsArray addObject:footerAttrs];
        }
        
    }
}

/** 决定一段区域所有cell和头尾视图的布局属性*/
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

/** 返回indexPath位置cell对应的布局属性*/
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    //设置布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes  layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = [self itemFrameOfVHCardFlow:indexPath];
    return attrs;
}

/** 返回indexPath位置头和脚视图对应的布局属性*/
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attri;
    if ([UICollectionElementKindSectionHeader isEqualToString:elementKind]) {
        //头视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
        attri.frame = [self headerViewFrameOfVerticalCardFlow:indexPath];
    }else {
        //脚视图
        attri = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
        attri.frame = [self footerViewFrameOfVerticalCardFlow:indexPath];
    }
    return attri;
}

//返回内容高度
-(CGSize)collectionViewContentSize {
    return CGSizeMake(0 , self.maxColumnHeight + self.edgeInsets.bottom);
}

#pragma mark - Help Methods
//竖向瀑布流 item等高不等宽
- (CGRect)itemFrameOfVHCardFlow:(NSIndexPath *)indexPath{
    
    //collectionView的宽度
    CGFloat collectionW = self.collectionView.frame.size.width;
    
    CGSize headViewSize = CGSizeMake(0, 0);
    if([self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForHeaderViewInSection:)]){
        headViewSize = [self.delegate cardFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    
    CGFloat w = [self.delegate cardFlowLayout:self sizeForItemAtIndexPath:indexPath].width;
    CGFloat h = [self.delegate cardFlowLayout:self sizeForItemAtIndexPath:indexPath].height;
    
    CGFloat x;
    CGFloat y;
    
    //记录最后一行的内容的横坐标和纵坐标
    if (collectionW - [[self.rowWidths firstObject] floatValue] > w + self.edgeInsets.right) {
        
        x = [[self.rowWidths firstObject] floatValue] == self.edgeInsets.left  ? self.edgeInsets.left : [[self.rowWidths firstObject] floatValue] + self.columnMargin;
        if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top) {
            y = self.edgeInsets.top;
        }else if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top + headViewSize.height) {
            y =  self.edgeInsets.top + headViewSize.height + self.rowMargin;
        }else{
            y = [[self.columnHeights firstObject] floatValue] - h;
        }
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w )];
        
        if ([[self.columnHeights firstObject] floatValue] == self.edgeInsets.top || [[self.columnHeights firstObject] floatValue] == self.edgeInsets.top + headViewSize.height) {
            [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
        }
        
    }else if(collectionW - [[self.rowWidths firstObject] floatValue] == w + self.edgeInsets.right){
        //换行
        x = self.edgeInsets.left;
        y = [[self.columnHeights firstObject] floatValue] + self.rowMargin;
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
        
    }else{
        //换行
        x = self.edgeInsets.left;
        y = [[self.columnHeights firstObject] floatValue]  + self.rowMargin;
        [self.rowWidths replaceObjectAtIndex:0 withObject:@(x + w)];
        [self.columnHeights replaceObjectAtIndex:0 withObject:@(y + h)];
    }
    
    //记录内容的高度
    self.maxColumnHeight = [[self.columnHeights firstObject] floatValue] ;
    
    return CGRectMake(x, y, w, h);
    
}

//返回头视图的布局frame
- (CGRect)headerViewFrameOfVerticalCardFlow:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if([self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForHeaderViewInSection:)]){
        size = [self.delegate cardFlowLayout:self sizeForHeaderViewInSection:indexPath.section];
    }
    CGFloat x = 0;
    CGFloat y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight;
    if (![self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForFooterViewInSection:)] || [self.delegate cardFlowLayout:self sizeForFooterViewInSection:indexPath.section].height == 0) {
        y = self.maxColumnHeight == 0 ? self.edgeInsets.top : self.maxColumnHeight + self.rowMargin;
    }
    self.maxColumnHeight = y + size.height ;
    
    [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.collectionView.frame.size.width)];
    [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
    return CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
}

//返回脚视图的布局frame
- (CGRect)footerViewFrameOfVerticalCardFlow:(NSIndexPath *)indexPath{
    CGSize size = CGSizeZero;
    if([self.delegate respondsToSelector:@selector(cardFlowLayout:sizeForFooterViewInSection:)]){
        size = [self.delegate cardFlowLayout:self sizeForFooterViewInSection:indexPath.section];
    }
    
    CGFloat x = 0;
    CGFloat y = size.height == 0 ? self.maxColumnHeight : self.maxColumnHeight + self.rowMargin;
    
    self.maxColumnHeight = y + size.height;
    
    [self.rowWidths replaceObjectAtIndex:0 withObject:@(self.collectionView.frame.size.width)];
    [self.columnHeights replaceObjectAtIndex:0 withObject:@(self.maxColumnHeight)];
    
    return  CGRectMake(x , y, self.collectionView.frame.size.width, size.height);
}
@end
