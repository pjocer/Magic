//
//  MyBaseViewController.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "MyBaseViewController.h"

@interface MyBaseViewController ()

@end

static NSString *const indentifier = @"cellId";

@implementation MyBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
    effectView.userInteractionEnabled = YES;
    
    [self createTableView];
    
    [self loadDataFromeDB];
}

- (void)loadDataFromeDB {

    [self.dataArray addObjectsFromArray:self.tmpArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height - 20)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:indentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    newDatasModel *model = _dataArray[indexPath.row];
    cell.datasModel = model;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayViewController *pvc = [PlayViewController sharePlayController];
    pvc.soundsArr = _dataArray;
    pvc.index = indexPath.row;
    [self.lcNavigationController pushViewController:pvc];
    
    pvc.dataModel = _dataArray[indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    newDatasModel *model = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DBManager sharedManager] deleteModelForAppId:model.id recordType:COLLEC_TYPE];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
@end
