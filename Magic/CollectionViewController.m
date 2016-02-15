//
//  CollectionViewController.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "CollectionViewController.h"

static NSString *const reuseIdentifier = @"indentifier";

@interface CollectionViewController ()<WaterFallFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.trelloListItem.rowItemsArray removeAllObjects];
    [self createMask];
    self.view.backgroundColor = [UIColor clearColor];
    [self createMagicBg];
    [self createCollectionView];
    
    [self createTopView];
}

- (void)createTopView {
    CGRect frame = CGRectMake(0, 0, ScreenWidth - 60.0f, 44);
    TopTitleView *topView = [[TopTitleView alloc] initWithFrame:frame];
    topView.topTitle = @"最热频道";
    [self.view addSubview:topView];
}

- (void)createMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,
                                                                                0.0f,
                                                                                ScreenWidth - 60.0f,
                                                                                self.view.height - 110)
                                                   byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _selfFrame;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    self.view.userInteractionEnabled = YES;
}

- (void)createMagicBg {
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
//                                                                           0.0f,
//                                                                           ScreenWidth - 60.0f,
//                                                                           self.view.height + 90 - 44)];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.frame = CGRectMake(0,
                                  0.0f,
                                  ScreenWidth - 60.0f,
                                  self.view.height + 90 - 44);
//    imageView.userInteractionEnabled = YES;
    _effectView.userInteractionEnabled = YES;
//    [self.view addSubview:imageView];
    [self.view addSubview:_effectView];
}

- (void)createDownloadUrl {
    
    _downLoadUrl = NEW_URL;
}

- (void)refresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataFromNet:NO];
    }];
    self.collectionView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadDataFromNet:YES];
    }];
    self.collectionView.mj_footer = footer;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadDataFromNet:(BOOL)isMore {
    NSInteger page = 1;
    
    BOOL isConnect = [XWBaseMethod connectionInternet];
    
    static NSInteger refreshCount = 0;
    refreshCount++;
    
    if (!isConnect && refreshCount > 2) {
        [XWBaseMethod showErrorWithStr:@"网络连接异常" toView:self.view];
        isMore ? [self.collectionView.mj_footer endRefreshing] : [self.collectionView.mj_header endRefreshing];
        return;
    } else {
        [XWBaseMethod showHUDAddedTo:self.view animated:YES];
    }
    
    if (isMore) {
        // 删除一个频道后
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
                [self.collectionView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
            if (page > 8) {
                [self.collectionView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
        } else {
            // 未删除之前
            if (self.trelloListItem.rowItemsArray.count % 10 == 0) {
                page = self.trelloListItem.rowItemsArray.count / 10 + 1;
            } else {
                [self.collectionView.mj_footer endRefreshing];
                [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
                return;
            }
        }
    } else {
        [self.trelloListItem.rowItemsArray removeAllObjects];
        [self.collectionView reloadData];
    }
    NSString *urlStr = [NSString stringWithFormat:_downLoadUrl, page];
    
    if (!isConnect) {
        NSData *cacheData = [JWCache objectForKey:MD5Hash(urlStr)];
        if (cacheData) {
            NewDataModel *dataModel = [[NewDataModel alloc] initWithData:cacheData error:nil];
            for (newDatasModel *model in dataModel.result.detailData) {
#if ALLOW
                if ([model.id isEqualToString:@"52"] ||
                    [model.id isEqualToString:@"1158"] ||
                    [model.id isEqualToString:@"1148"] ||
                    [model.id isEqualToString:@"1147"] ||
                    [model.id isEqualToString:@"1125"] ||
                    [model.id isEqualToString:@"56"] ||
                    [model.id isEqualToString:@"1148"] ||
                    [model.id isEqualToString:@"196"] ||
                    [model.id isEqualToString:@"1090"]) {
                    continue;
                }
#endif
                NSLog(@"%@", model.id);
                [self.trelloListItem.rowItemsArray addObject:model];
            }
            [self.collectionView reloadData];
            isMore ? [self.collectionView.mj_footer endRefreshing] : [self.collectionView.mj_header endRefreshing];
            [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
            return;
        }
    }
    __weak typeof(self) wSelf = self;
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NewDataModel *dataModel = [[NewDataModel alloc] initWithData:responseObject error:nil];
        for (newDatasModel *model in dataModel.result.detailData) {
#if ALLOW
            if ([model.id isEqualToString:@"52"] ||
                [model.id isEqualToString:@"1158"] ||
                [model.id isEqualToString:@"1148"] ||
                [model.id isEqualToString:@"1147"] ||
                [model.id isEqualToString:@"1125"] ||
                [model.id isEqualToString:@"56"] ||
                [model.id isEqualToString:@"1148"] ||
                [model.id isEqualToString:@"196"] ||
                [model.id isEqualToString:@"1090"]) {
                continue;
            }
#endif
            [wSelf.trelloListItem.rowItemsArray addObject:model];
        }
        [wSelf.collectionView reloadData];
        isMore ? [wSelf.collectionView.mj_footer endRefreshing] : [wSelf.collectionView.mj_header endRefreshing];
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
        [JWCache setObject:responseObject forKey:MD5Hash(urlStr)];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        isMore ? [wSelf.collectionView.mj_footer endRefreshing] : [wSelf.collectionView.mj_header endRefreshing];
        NSLog(@"%@", error.description);
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewLayout *)createLayout {
    WaterFallFlowLayout *layout = [[WaterFallFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
//    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.numberOfColumns = 2;
    layout.delegate = self;
    return layout;
}

- (void)createCollectionView {
    [self createDownloadUrl];
    CGRect frame = CGRectMake(0, 40, ScreenWidth - 60.0f, self.view.height - 145);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:[self createLayout]];
    [_collectionView registerClass:[MyCollectionViewCell class]
        forCellWithReuseIdentifier:reuseIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [self refresh];
}

- (CGFloat)waterFallFlowLayout:(WaterFallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f + arc4random_uniform(self.view.width * 0.3);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView *view = nil;
    if (view == nil) {
        view = [UIImageView new];
    }
    newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
    cell.datasModel = datasModel;
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 3.0;
    [[SDImageCache sharedImageCache] clearMemory];
    //NSLog(@"%@", datasModel.pic_200);
    if (!datasModel.pic_200) {
        [view sd_setImageWithURL:[NSURL URLWithString:datasModel.pic_500] placeholderImage:nil];
    } else {
        [view sd_setImageWithURL:[NSURL URLWithString:datasModel.pic_200] placeholderImage:nil];
    }
    cell.backgroundView = view;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.trelloListItem.rowItemsArray.count;
}

@end
