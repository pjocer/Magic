//
//  CollectionViewController.h
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CollectionViewController : BaseViewController

@property (nonatomic, strong) TrelloListItem *trelloListItem;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGRect  selfFrame;

@property (nonatomic, copy) NSString *downLoadUrl;

@property (nonatomic, strong) UIVisualEffectView *effectView;


- (void)createMagicBg;

@end
