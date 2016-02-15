//
//  WaterFallFlowLayout.m
//  03-瀑布流
//
//  Created by PerryJump on 15/11/18.
//  Copyright © 2015年 mxl. All rights reserved.
//

#import "WaterFallFlowLayout.h"

@interface WaterFallFlowLayout ()

@property (nonatomic, copy) NSMutableArray *columnsHeights;//该数组用于记录所有列的高度
@property (nonatomic, copy) NSMutableArray *itemsAttributes;//该数组用于记录布局的所有item的属性信息

@end
/**
 minimumLineSpacing;
 minimumInteritemSpacing;
 sectionInset;
 numberOfColumns;
 */
@implementation WaterFallFlowLayout



- (void)setMinimumLineSpacing:(CGFloat)minimumLineSpacing{
    
//    如果布局不一样，重新布局
    if (_minimumInteritemSpacing != minimumLineSpacing) {
        _minimumInteritemSpacing = minimumLineSpacing;
//        让原来的布局失效..失效后会调用prepareLayout方法
        [self invalidateLayout];
    }
}

- (void)setMinimumInteritemSpacing:(CGFloat)minimumInteritemSpacing{

    if (_minimumInteritemSpacing != minimumInteritemSpacing) {
        _minimumInteritemSpacing  = minimumInteritemSpacing;
        [self invalidateLayout];
    }
}

- (void)setSectionInset:(UIEdgeInsets)sectionInset{

//    判断两个UIEdgeInsets是否相同
    if (!UIEdgeInsetsEqualToEdgeInsets(_sectionInset, sectionInset)) {
        _sectionInset = sectionInset;
        [self invalidateLayout];
    }
}

- (void)setNumberOfColumns:(NSUInteger)numberOfColumns{

    if (_numberOfColumns != numberOfColumns) {
        _numberOfColumns = numberOfColumns;
        [self invalidateLayout];
    }
}
//重写方法1:准备布局
- (void)prepareLayout{
    [super prepareLayout];
    if (_columnsHeights) {
        [_columnsHeights removeAllObjects];
    }else{
        _columnsHeights = [[NSMutableArray alloc]init];
    }
    if (_itemsAttributes) {
        [_itemsAttributes removeAllObjects];
    }else{
        _itemsAttributes = [[NSMutableArray alloc]init];
    }

//    设置每一列的开始布局高度,初始化高度是上边距
    for (NSUInteger i = 0; i < self.numberOfColumns; i++) {
        [_columnsHeights addObject:@(self.sectionInset.top)];
    }
//    布局开始
    
//    计算item的宽度
    CGFloat totalWidth = self.collectionView.frame.size.width;//总宽度
    CGFloat validWidth = totalWidth - self.sectionInset.left - self.sectionInset.right - (self.numberOfColumns - 1) * self.minimumInteritemSpacing;//每一行所有item的宽度
    CGFloat itemWidth = validWidth / self.numberOfColumns;//每一个item的宽度
    

//    获取item的个数
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
//    计算item的高度
    for (NSUInteger i = 0; i < count; i++) {
//        放置代理对象可能没有设置高度，给itemHeight一个默认高度
        CGFloat itemHeight = itemWidth;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        这里预防代理没有设置，如果代理没有设置不判断程序会崩溃,有响应就用的到的值
        if ([self.delegate respondsToSelector:@selector(waterFallFlowLayout:heightForItemAtIndexPath:)]) {
//            有响应(代理已经设置)向代理对象索取item的高度
            itemHeight = [self.delegate waterFallFlowLayout:self heightForItemAtIndexPath:indexPath];
        }
//        计算原点坐标位置
        NSUInteger shortest = [self indexOfShortestColumn];//找到最短列
        CGFloat originX = self.sectionInset.left + shortest * (self.minimumInteritemSpacing + itemWidth);
        CGFloat originY = [_columnsHeights[shortest] floatValue] + self.sectionInset.bottom;
        
//        得到要布局的位置frame
        CGRect frame = CGRectMake(originX, originY, itemWidth, itemHeight);
//        创建属性对象，并保存frame
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
//        把属性对象保存到数组中
        [_itemsAttributes addObject:attr];
        
        
//        更新最短列的高度
        [_columnsHeights replaceObjectAtIndex:shortest withObject:@(originY + itemHeight + self.minimumLineSpacing)];
    }
//    重新加载数据
    [self.collectionView reloadData];
}
//重写方法2:返回与指定区域(rect)有交集的所有item的属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *array = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *attr in _itemsAttributes) {
//        判断两个区域是否有交集
        if (CGRectIntersectsRect(attr.frame, rect)) {
            [array addObject:attr];
        }
    }
    return array;
}
//重写方法3:返回指定item的属性(返回frame)
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    NSLog(@"11%@", indexPath);
//    return _itemsAttributes[indexPath.item];
//}
//重写方法4:滚动视图内容尺寸
- (CGSize)collectionViewContentSize{

    NSUInteger longest = [self indexOfLongestColumn];
//    视图内容高度应该是最长列的高度减去上下间距，然后加上周围的边距
    CGFloat height = [_columnsHeights[longest] floatValue] - self.minimumLineSpacing + self.sectionInset.bottom;
    CGFloat width = self.collectionView.frame.size.width;
    return CGSizeMake(width, height);
}
//返回数组中最短列的下标
- (NSInteger)indexOfShortestColumn{
    NSInteger index = 0;
    for (NSInteger i = 1; i < _numberOfColumns; i++) {
        if ([_columnsHeights[i] floatValue] < [_columnsHeights[index] floatValue]) {
            index = i;
        }
    }
    return index;
}
//返回数组中最长列的下标
- (NSInteger)indexOfLongestColumn{
    NSInteger index = 0;
    for (NSInteger i = 1; i < _numberOfColumns; i++) {
        if ([_columnsHeights[i] floatValue] > [_columnsHeights[index] floatValue]) {
            index = i;
        }
    }
    return index;
}

@end























