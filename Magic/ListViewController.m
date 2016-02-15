//
//  ListViewController.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ListViewController.h"
#import "TrelloListTableView.h"


@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSInteger refreshCount;

@property (nonatomic, strong) UIButton *sugBtn;
@property (nonatomic, strong) UIButton *myBtn;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.trelloListItem.rowItemsArray removeAllObjects];
    self.view.backgroundColor = [UIColor clearColor];
    _selfFrame = CGRectMake(0,
                            0.0f,
                            ScreenWidth - 60.0f,
                            self.view.height - 110);
    /**
     *  圆角
     */
    [self createMask];
    /**
     *  背景磨砂图
     */
    [self createMagicBg];
    
    [self createScrollView];
    /**
     *  创建tableView
     */
    [self createTableView];
    
    [self createMyView];
    
    [self createTopView];
}

- (void)createScrollView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0,
                                   44.0f,
                                   ScreenWidth - 60.0f,
                                   self.view.height - 110);
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake((ScreenWidth - 60.0f) * 2, self.view.height - 110);
    [self.view addSubview:_scrollView];
}

- (void)sugClick:(UIButton *)btn {
    _myBtn.selected = NO;
    _sugBtn.selected = YES;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)myClick:(UIButton *)btn {
    _myBtn.selected = YES;
    _sugBtn.selected = NO;
    [self.scrollView setContentOffset:CGPointMake(ScreenWidth - 60.0f, 0) animated:YES];
}

- (void)createMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_selfFrame
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _selfFrame;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

- (void)createMagicBg {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0.0f,
                                                                           ScreenWidth - 60.0f,
                                                                           self.view.height - 110)];
    imageView.userInteractionEnabled = YES;
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0,
                                  0.0f,
                                  ScreenWidth - 60.0f,
                                  self.view.height - 110);
    [self.view addSubview:imageView];
    [self.view addSubview:effectView];
}

- (void)createDownloadUrl {

    _downLoadUrl = SUG_URL;
}

- (void)createTableView {
    
    [self createDownloadUrl];
    
    _trelloListTableView = [[TrelloListTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60.0f, self.view.height - 164)
                                                                style:UITableViewStylePlain
                                                             listItem:_trelloListItem];
    [self.scrollView addSubview:_trelloListTableView];
    
    [self refresh];
}

- (void)createMyView {
//    PersonalViewController *pvc = [[PersonalViewController alloc] init];
//    pvc.view.frame = CGRectMake(ScreenWidth - 60.0f,
//                                0.0f,
//                                ScreenWidth - 60.0f,
//                                self.view.height - 110.0f);
//    [self.scrollView addSubview:pvc.view];
    _dataArray = @[@"我喜欢", @"最近听过"
                   , @"我的下载"
                   ];
    [self createTableView1];
}

#pragma mark - TableView1

- (void)createTableView1 {
    
    _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth - 60, 0, ScreenWidth - 60, self.view.height - 110.0f)];
    
    _tableView1.dataSource = self;
    _tableView1.delegate = self;
    _tableView1.backgroundColor = [UIColor clearColor];
    _tableView1.separatorColor = [UIColor colorWithWhite:0.500 alpha:0.700];
    _tableView1.tableFooterView = [UIView new];
    [self.scrollView addSubview:_tableView1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"indentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = CELL_SEL_COLOR;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            MyloveViewController *mlv = [[MyloveViewController alloc] init];
            NSArray *array = [[DBManager sharedManager] readModelsWithRecordType:COLLEC_TYPE];
            if (array.count == 0) {
                [XWBaseMethod showErrorWithStr:@"您还没有添加喜欢歌曲" toView:self.view];
                return;
            }
            
            mlv.tmpArray = array;

            [self.lcNavigationController pushViewController:mlv];
        }
            break;
        case 1: {
            MyLastViewController *mvc = [[MyLastViewController alloc] init];
            NSArray *array = [[DBManager sharedManager] readModelsWithRecordType:LAST_TYPE];
            if (array.count == 0) {
                [XWBaseMethod showErrorWithStr:@"您没有最近听过的歌曲" toView:self.view];
                return;
            }
            mvc.tmpArray = array;
            
            [self.lcNavigationController pushViewController:mvc];
        }
            break;
        case 2: {
            MyDownViewController *mdc = [[MyDownViewController alloc] init];
            NSArray *array = [[DBManager sharedManager] readModelsWithRecordType:DOWN_TYPE];
            if (array.count == 0) {
                [XWBaseMethod showErrorWithStr:@"您没有下载的歌曲" toView:self.view];
                return;
            }
            mdc.tmpArray = array;

            [self.lcNavigationController pushViewController:mdc];
        }
            break;
        default:
            break;
    }
}

- (void)createTopView {
    CGRect frame = CGRectMake(0, 0, _selfFrame.size.width, 44);
    TopTitleView *topView = [[TopTitleView alloc] initWithFrame:frame];
    topView.topTitle = @"";
    [self.view addSubview:topView];
    
    _sugBtn = [UIButton new];
    _sugBtn.frame = CGRectMake(0, 5, 100, 30);
    [_sugBtn setTitle:@"推荐声音"
             forState:UIControlStateNormal];
    [_sugBtn setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    [_sugBtn setTitleColor:[UIColor redColor]
                  forState:UIControlStateSelected];
    [_sugBtn addTarget:self
                action:@selector(sugClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [_sugBtn setSelected:YES];
    [self.view addSubview:_sugBtn];
    
    _myBtn = [UIButton new];
    CGFloat hotX = CGRectGetMaxX(_sugBtn.frame) + 5;
    _myBtn.frame = CGRectMake(hotX, 5, 100, 30);
    [_myBtn setTitleColor:[UIColor blackColor]
                 forState:UIControlStateNormal];
    [_myBtn setTitleColor:[UIColor redColor]
                 forState:UIControlStateSelected];
    [_myBtn setTitle:@"我的曲库" forState:UIControlStateNormal];
    [_myBtn addTarget:self
               action:@selector(myClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_myBtn];
}


- (void)refresh {

    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataFromNet:NO];
    }];
    self.trelloListTableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFromNet:YES];
    }];
    self.trelloListTableView.mj_footer = footer;
    
    [self.trelloListTableView.mj_header beginRefreshing];
}



- (void)loadDataFromNet:(BOOL)isMore {
    
    BOOL isConnect = [XWBaseMethod connectionInternet];
    
    if (!isConnect && _refreshCount > 2) {
        [XWBaseMethod showErrorWithStr:@"网络异常" toView:self.view];
        isMore ?
        [self.trelloListTableView.mj_footer endRefreshing] :
        [self.trelloListTableView.mj_header endRefreshing];
        return;
    } else {
        [XWBaseMethod showHUDAddedTo:self.view animated:YES];
    }
    
    NSInteger page = 1;
    if (isMore) {
        if (self.trelloListItem.rowItemsArray.count % 10 != 0) {
            if ((self.trelloListItem.rowItemsArray.count + 1) % 10 == 0) {
                page = (self.trelloListItem.rowItemsArray.count + 1) / 10 + 1;
            } else if ((self.trelloListItem.rowItemsArray.count + 2) % 10 == 0) {
                page = (self.trelloListItem.rowItemsArray.count + 2) / 10 + 1;
            } else if ((self.trelloListItem.rowItemsArray.count + 3) % 10 == 0) {
                page = (self.trelloListItem.rowItemsArray.count + 3) / 10 + 1;
            } else if ((self.trelloListItem.rowItemsArray.count + 4) % 10 == 0) {
                page = (self.trelloListItem.rowItemsArray.count + 4) / 10 + 1;
            } else if ((self.trelloListItem.rowItemsArray.count + 5) % 10 == 0) {
                page = (self.trelloListItem.rowItemsArray.count + 5) / 10 + 1;
            }
            else {
                [self.trelloListTableView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
            if (page > 8) {
                [self.trelloListTableView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
        } else {
            // 未删除之前
            if (self.trelloListItem.rowItemsArray.count % 10 == 0) {
                page = self.trelloListItem.rowItemsArray.count / 10 + 1;
            } else {
                [self.trelloListTableView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
        }
    } else {
        
        [self.trelloListItem.rowItemsArray removeAllObjects];
        [self.trelloListTableView reloadData];
    }
    _refreshCount++;
    NSString *urlStr = [NSString stringWithFormat:_downLoadUrl, page];
    
    NSData *cacheData = [JWCache objectForKey:MD5Hash(urlStr)];
    
    if (cacheData && !isConnect) {
        NewDataModel *datamodel = [[NewDataModel alloc] initWithData:cacheData error:nil];
        [self.trelloListItem.rowItemsArray addObjectsFromArray:datamodel.result.detailData];
        [self.trelloListTableView reloadData];
        isMore ?
        [self.trelloListTableView.mj_footer endRefreshing] :
        [self.trelloListTableView.mj_header endRefreshing];
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
        return;
    }
    
    __weak typeof(self) wSelf = self;
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NewDataModel *dataModel = [[NewDataModel alloc] initWithData:responseObject error:nil];
        for (newDatasModel *datas in dataModel.result.detailData) {
#if ALLOW
            if ([datas.id isEqualToString:@"6866"] ||
                [datas.id isEqualToString:@"156405"] ||
                [datas.id isEqualToString:@"215465"] ||
                [datas.id isEqualToString:@"1033649"] ||
                [datas.id isEqualToString:@"92260"]) {
                continue;
            }
#endif
            [wSelf.trelloListItem.rowItemsArray addObject:datas];
        }
        //[wSelf.trelloListItem.rowItemsArray addObjectsFromArray:dataModel.result.detailData];
        [wSelf.trelloListTableView reloadData];
        
        isMore ?
        [wSelf.trelloListTableView.mj_footer endRefreshing] :
        [wSelf.trelloListTableView.mj_header endRefreshing];
        [JWCache setObject:responseObject forKey:MD5Hash(urlStr)];
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
        isMore ?
        [wSelf.trelloListTableView.mj_footer endRefreshing] :
        [wSelf.trelloListTableView.mj_header endRefreshing];
        
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
