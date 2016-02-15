//
//  HomeViewController.h
//  Magic
//
//  Created by mxl on 16/1/3.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+Awesome.h"
#import "TrelloListTabView.h"
#import "TrelloListView.h"
#import "TrelloView.h"
#import "UIImage+ImageWithColor.h"
#import "TrelloListCellItem.h"

@interface HomeViewController : BaseViewController<UIScrollViewDelegate, TrelloDataSource>

@property (nonatomic, strong) TrelloView *trelloView;

@end
