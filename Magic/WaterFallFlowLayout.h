//
//  WaterFallFlowLayout.h
//  03-瀑布流
//
//  Created by PerryJump on 15/11/18.
//  Copyright © 2015年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFallFlowLayout;

@protocol WaterFallFlowLayoutDelegate <NSObject>

//创建协议得到高度
- (CGFloat)waterFallFlowLayout:(WaterFallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFallFlowLayout : UICollectionViewLayout

//代理对象提供高度
@property (nonatomic, assign) id<WaterFallFlowLayoutDelegate> delegate;

@property (nonatomic, assign) CGFloat           minimumLineSpacing;
@property (nonatomic, assign) CGFloat           minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets      sectionInset;

@property (nonatomic, assign) NSUInteger        numberOfColumns;//列数



@end
