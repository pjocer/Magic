//
//  MyDownViewController.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "MyDownViewController.h"

@interface MyDownViewController ()

@end

@implementation MyDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadDataFromeDB {

    [self.dataArray addObjectsFromArray:self.tmpArray];
    [self.tableView reloadData];

}


@end
