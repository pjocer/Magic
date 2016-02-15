//
//  ClassViewController.m
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController ()<UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self loadDataFromeTxt];
    
    [self createTableView];
    
    [self createTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTopView {
    CGRect frame = CGRectMake(0, 0, ScreenWidth - 60.0f, 44);
    TopTitleView *topView = [[TopTitleView alloc] initWithFrame:frame];
    topView.topTitle = @"分类";
    [self.view addSubview:topView];
}

- (void)loadDataFromeTxt {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSON_CategoryInfo"
                                                     ofType:@"txt"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSMutableArray *tmpArr = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    NSArray *array = [[tmpArr valueForKey:@"result"] valueForKey:@"data"];
    for (id obj in array) {
        ClassModel *model = [[ClassModel alloc] init];
        [model setValuesForKeysWithDictionary:obj];
        if ([model.name isEqualToString:@"儿童"]) {
            continue;
        }
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               40,
                                                               ScreenWidth - 60.0f,
                                                               self.view.height - 154)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassTableViewCell *cell = [ClassTableViewCell customClassTableView:tableView];
    ClassModel *model = _dataArray[indexPath.row];
    cell.model = model;

    cell.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"CellImage%.3ld", indexPath.row + 1]];
    cell.nameLabel.text = model.name;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (ScreenWidth - 60.0f) / 9.0 * 4.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassModel *model = _dataArray[indexPath.row];
    ClassChannelController *ccc = [[ClassChannelController alloc] init];
    ccc.classUrl = [NSString stringWithFormat:CLASS_ONE, model.ID];
    TrelloListItem *listItem = [[TrelloListItem alloc] init];
    ccc.trelloListItem = listItem;
    ccc.view.frame = CGRectMake(30, 60, self.view.width, self.view.height);
    self.lcNavigationController.pageType = PageTypeLastFir;
    
    self.lcNavigationController.pageFrame = CGRectMake(30, 60, self.view.width, self.view.height);

    [self.lcNavigationController pushViewController:ccc completion:^{
        
    }];
    ccc.className = model.name;
}

@end
