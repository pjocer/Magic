//
//  ListViewController.h
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "BaseViewController.h"

@interface ListViewController : BaseViewController

@property (nonatomic, strong) TrelloListItem *trelloListItem;

@property (nonatomic, strong) TrelloListTableView *trelloListTableView;

@property (nonatomic, assign) CGRect  selfFrame;

@property (nonatomic, copy) NSString *downLoadUrl;

- (void)createMagicBg;

- (void)createTableView;

@end
