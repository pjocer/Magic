//
//  MyBaseViewController.h
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBaseViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *tmpArray;

@end
