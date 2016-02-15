//
//  PersonalViewController.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "PersonalViewController.h"

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    _dataArray = @[@"我喜欢", @"最近听过", @"我的下载"];
    [self createTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTableView {
    /**
     CGRectMake(ScreenWidth - 60.0f,
     0.0f,
     ScreenWidth - 60.0f,
     self.view.height - 110.0f);
     
     */
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60.0f, self.view.height / 2)];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
//    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = [UIColor colorWithWhite:0.500 alpha:0.700];
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"indentifierrr";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELL_SEL_COLOR;
    cell.backgroundColor = [UIColor redColor];
//    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            
        }
        default:
            break;
    }
}


@end
