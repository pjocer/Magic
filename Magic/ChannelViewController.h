//
//  ChannelViewController.h
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ChannelViewController : BaseViewController

@property (nonatomic, strong) TrelloListItem *trelloListItem;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) CGRect  selfFrame;

@property (nonatomic, copy) NSString *channelID;

@property (nonatomic, assign) BOOL isLastPage;

@end
