//
//  YJYYWaterFlowLayout.m
//  远洋瀑布流
//
//  Created by 远洋 on 16/1/28.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import "YJYYWaterFlowLayout.h"


/** 默认的列数 */
static const NSInteger YJYYDefaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat YJYYDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat YJYYDefaultRowMargin = 10;
/** 边缘间距 不能直接等于UIEdgeInsetsMake创建  但是可以使用结构体的方式赋值"{}"*/
static const UIEdgeInsets YJYYDefaultEdgeInsets = {10, 10, 10, 10};


@interface YJYYWaterFlowLayout ()

/** 存放所有列的当前高度 使用数组是为了方便管理 而且采用遍历的方式去比较列最短高度*/
@property (nonatomic, strong) NSMutableArray *columnHeights;

/** 存放每个cell对应的布局属性 */
@property (nonatomic, strong) NSMutableArray * attrsArray;

/** 内容的高度 */
@property (nonatomic,assign)CGFloat contentHeight;

//方法声明 目的是调用时可以以点的形式出来
- (CGFloat)itemRowMargin;
- (CGFloat)itemColumnMargin;
- (NSInteger)itemcolumnCount;
- (UIEdgeInsets)itemEdgeInsets;
@end
@implementation YJYYWaterFlowLayout

#pragma mark - /********常见数据处理*******/
//行间距
-(CGFloat)itemRowMargin{
    return self.rowMargin != nil ? self.rowMargin() : YJYYDefaultRowMargin;
}

//总列数
-(NSInteger)itemcolumnCount {
    return self.columnCount != nil ? self.columnCount() : YJYYDefaultColumnCount;
}

//列间距
-(CGFloat)itemColumnMargin {
    return self.columMargin != nil ? self.columMargin() : YJYYDefaultColumnMargin;
}

//四周间距
-(UIEdgeInsets)itemEdgeInsets {
    return self.edgeInsets != nil ? self.edgeInsets() : YJYYDefaultEdgeInsets;
}

#pragma mark - /********懒加载部分*******/
-(NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

-(NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

#pragma mark - /********重写部分*******/
-(void)prepareLayout
{
    [super prepareLayout];
    //默认初始的内容高度为0
    self.contentHeight = 0;
    
    //清除以前计算的当前列的高度
    [self.columnHeights removeAllObjects];
    
    //给每一个列设置一个初始的当前高度
    for (NSInteger i = 0; i < self.itemRowMargin; i++) {
        [self.columnHeights addObject:@(self.itemEdgeInsets.top)];
    }
    
    //清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    
    //创建每一个cell对应的布局属性 添加到数组中
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    //循环添加布局属性到数组中
    for (NSInteger i = 0 ; i < count; i++) {
        //获取索引
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //取出当前索引的布局属性
        UICollectionViewLayoutAttributes * attr = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrsArray addObject:attr];
    }
}

/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes * attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    //item的宽度
    CGFloat w = (collectionViewW - self.itemEdgeInsets.left - self.itemEdgeInsets.right - (self.itemcolumnCount - 1) * self.itemColumnMargin)/ self.itemcolumnCount;
    
    //item的高度
    NSAssert(self.itemHeight != nil, @"传入的block不为空");
    //传入宽度 等比例设置
    CGFloat h = self.itemHeight(indexPath.item,w);
    
    /**
     需要计算出 每一列中最短高度的那一列 这是“核心”
     遍历_columnHeights获取最短高度的列号 和 高度
     */
    //记录最短高度列号
    NSInteger resultColumnNum = 0;
    //记录最短高度 默认就等于数组的第0个元素 减少遍历次数
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.itemcolumnCount; i++) {
        //先取出第i列的高度 转成double 因为数组中只能存对象
        CGFloat columHeight = [self.columnHeights[i] doubleValue];
        
        //开始比较每一列的最短高度
        if (minColumnHeight > columHeight) {
            minColumnHeight = columHeight;
            //记录最短列的列号
            resultColumnNum = i;
        }
    }
    
    //item的x值 跟九宫格算法其实一样
    CGFloat x = self.itemEdgeInsets.left + (w + self.itemColumnMargin) * resultColumnNum;
    //item的y值 第一行时就直接等于最短高度
    CGFloat y = minColumnHeight;
    if (y != self.itemEdgeInsets.top) {
        //不是第一行就累加
        y += self.itemRowMargin;
    }
    
    //计算attr的frame 也就是item摆放的位置 注意不要写在下面一句代码的后面
    attr.frame = CGRectMake(x, y , w, h);
    
    //最后更新一下最短那列的高度 必须做 包装成NSNumber对象
    self.columnHeights[resultColumnNum] = @(CGRectGetMaxY(attr.frame));
    
    //记录内容的高度 也就是整个collectionView显示item的高度
    //默认就是最短列的的高度 可以减少一次遍历
    CGFloat contentH = [self.columnHeights[resultColumnNum] doubleValue];
    
    if (self.contentHeight < contentH) {
        //给属性内容高度赋值
        self.contentHeight = contentH;
    }
    return attr;
}

/**
 返回整个collectionView要展示的内容高度
 */
- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.contentHeight + self.itemEdgeInsets.bottom);
}


@end
