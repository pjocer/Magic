//
//  TrelloListTableViewCell.h
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/6.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrelloListCellItem.h"
#import "NewDataModel.h"

@interface TrelloListTableViewCell : UITableViewCell

@property (nonatomic, strong) newDatasModel *item;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *colorIndicatorView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *detailImageView;

@property (nonatomic, strong) UILabel *fromLabel;

@end
