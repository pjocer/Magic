//
//  MyLastViewController.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "MyLastViewController.h"

@interface MyLastViewController ()

@end

@implementation MyLastViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
