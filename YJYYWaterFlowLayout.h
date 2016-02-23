//
//  YJYYWaterFlowLayout.h
//  远洋瀑布流
//
//  Created by 远洋 on 16/1/28.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YJYYWaterFlowLayout;
typedef CGFloat(^itemHeightBlcok)(NSInteger index, CGFloat itemWidth);
typedef NSInteger(^columnCountBlcok)();
typedef CGFloat(^columnMarginBlock)();
typedef CGFloat(^rowMarginBlcok)();
typedef UIEdgeInsets(^edgeInsetsBlcok)();

@interface YJYYWaterFlowLayout : UICollectionViewLayout
//item的高度
@property (nonatomic,copy)itemHeightBlcok  itemHeight;
//总列数
@property (nonatomic,copy)columnCountBlcok columnCount;
//列间距
@property (nonatomic,copy)columnMarginBlock columMargin;
//行间距
@property (nonatomic,copy)rowMarginBlcok rowMargin;
//collectionView四周的间距
@property (nonatomic,copy)edgeInsetsBlcok edgeInsets;

@end
