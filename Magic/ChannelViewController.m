//
//  ChannelViewController.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ChannelViewController.h"

#define HEADER_HEIGHT   230

static NSString *const reuseIndentifier = @"reuseID";
static NSString *const headerIndentifier = @"header";

@interface ChannelViewController ()<WaterFallFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NewChannelModel *channelModel;

@end

@implementation ChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.channelModel = [[NewChannelModel alloc] init];
//    self.view.backgroundColor = [UIColor clearColor];
    UIView *shawView = [UIView new];
    shawView.backgroundColor = [UIColor whiteColor];
    shawView.backgroundColor = [UIColor colorWithRed:0.038 green:0.062 blue:0.054 alpha:0.500];
    shawView.frame = self.view.bounds;
    [self.view addSubview:shawView];
    
    self.trelloListItem = [[TrelloListItem alloc] init];
    
    [self createCollectionView];
    
}

- (void)createBackBtn:(id)view {
    
#define BTN_ALPHA   0.130
    UIView *topShaw = [UIView new];
    topShaw.frame = CGRectMake(0, 0, ScreenWidth - 10, 35);
    topShaw.userInteractionEnabled = YES;
    topShaw.backgroundColor = [UIColor colorWithRed:0.024 green:0.030 blue:0.010 alpha:0.570];
    [view addSubview:topShaw];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImg = [UIImage imageNamed:@"lyric_up2@2x"];
    backBtn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:BTN_ALPHA + 0.03];
    backBtn.frame = CGRectMake(10, 3, 27, 27);
    backBtn.layer.cornerRadius = backBtn.width / 2;
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topShaw addSubview:backBtn];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:topShaw.frame];
    nameLabel.text = self.channelModel.name;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:15];
    [topShaw addSubview:nameLabel];
}

- (void)backBtnClick:(UIButton *)btn {
    [self.lcNavigationController popViewController];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UICollectionViewLayout *)createLayout {
#define CELL_W (self.view.width - 40) / 2
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumInteritemSpacing = 20;
    layout.itemSize = CGSizeMake(CELL_W, 100);
    layout.headerReferenceSize = CGSizeMake(10, HEADER_HEIGHT);
    return layout;
}

- (void)refresh {
    
    __weak typeof(self) wSelf = self;
//    MJRefreshHeader
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf loadDataFromNet:NO];
    }];
    self.collectionView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wSelf loadDataFromNet:YES];
    }];
    self.collectionView.mj_footer = footer;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadDataFromNet:(BOOL)isMore {
    
    
    static NSInteger refreshCount = 0;
    refreshCount++;
    BOOL isConnect = [XWBaseMethod connectionInternet];
    
    if (refreshCount > 2 && !isConnect) {
        [XWBaseMethod showErrorWithStr:@"网络连接错误" toView:self.view];
        isMore ? [self.collectionView.mj_footer endRefreshing] : [self.collectionView.mj_header endRefreshing];
        return;
    } else {
        [XWBaseMethod showHUDAddedTo:self.view animated:YES];
    }
    NSInteger page = 1;
    if (isMore) {
        if (self.trelloListItem.rowItemsArray.count % 10 == 0) {
            page = self.trelloListItem.rowItemsArray.count / 10 + 1;
        } else {
            [self.collectionView.mj_footer endRefreshing];
            [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
            return;
        }
    } else {
        [self.trelloListItem.rowItemsArray removeAllObjects];
        [self.collectionView reloadData];
    }
    NSString *urlStr = [NSString stringWithFormat:CHANNEL, _channelID, (long)page];
    
    NSData *cacheData = [JWCache objectForKey:MD5Hash(urlStr)];
    if (cacheData && !isConnect) {
        SoundsModel *dataModel = [[SoundsModel alloc] initWithData:cacheData error:nil];
        self.channelModel = dataModel.result.detailData.channel;
        [self.trelloListItem.rowItemsArray addObjectsFromArray:dataModel.result.detailData.sounds];
        [self.collectionView reloadData];
        isMore ? [self.collectionView.mj_footer endRefreshing] : [self.collectionView.mj_header endRefreshing];
        [XWBaseMethod hideHUDAddedTo:self.view animated:YES];
        return;
    }
    __weak typeof(self) wSelf = self;
    [self.manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        SoundsModel *dataModel = [[SoundsModel alloc] initWithData:responseObject error:nil];
        wSelf.channelModel = dataModel.result.detailData.channel;
        [wSelf.trelloListItem.rowItemsArray addObjectsFromArray:dataModel.result.detailData.sounds];
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

- (void)createCollectionView {
    CGRect frame = CGRectMake(0, 20, ScreenWidth, self.view.height - 20);
    _collectionView = [[UICollectionView alloc] initWithFrame:frame
                                         collectionViewLayout:[self createLayout]];
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:reuseIndentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIndentifier];
    
    [self.view addSubview:_collectionView];
    [self refresh];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:headerIndentifier
                                                                                   forIndexPath:indexPath];
        UIImageView *imageView = nil;
        if (imageView == nil) {
            imageView = [UIImageView new];
            imageView.layer.cornerRadius = 3;
            [view addSubview:imageView];
            [self createBackBtn:imageView];
        }
        imageView.frame = CGRectMake(5, 0, ScreenWidth - 10, HEADER_HEIGHT);
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.channelModel.pic] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;

        return view;
    }
    return nil;
}

- (CGFloat)waterFallFlowLayout:(WaterFallFlowLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_W / 9.0 * 4.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIndentifier forIndexPath:indexPath];
    UIImageView *view = nil;
    if (view == nil) {
        view = [UIImageView new];
    }
    newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
    cell.datasModel = datasModel;
    cell.clipsToBounds = YES;
    cell.layer.cornerRadius = 3.0;
    [[SDImageCache sharedImageCache] clearMemory];
    if (!datasModel.pic_500) {
        [view sd_setImageWithURL:[NSURL URLWithString:datasModel.pic_200] placeholderImage:nil];
    } else {
        [view sd_setImageWithURL:[NSURL URLWithString:datasModel.pic_500] placeholderImage:nil];
    }
    cell.backgroundView = view;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.trelloListItem.rowItemsArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![XWBaseMethod connectionInternet]) {
        [XWBaseMethod showErrorWithStr:@"网络异常" toView:self.view];
        return;
    }
    __weak typeof(self) wSelf = self;
    [LGReachability LGwithSuccessBlock:^(NSString *status) {
        if ([status isEqualToString: @"3G/4G网络"] || [status isEqualToString: @"无连接"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"当前为移动网络,是否继续播放" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                PlayViewController *pvc = [PlayViewController sharePlayController];
                newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
                pvc.soundsArr = self.trelloListItem.rowItemsArray;
                pvc.index = indexPath.item;
                
                if (self.isLastPage) {
                    self.lcNavigationController.pageType = PageTypeLastLast;
                    self.lcNavigationController.isComment = NO;
                } else {
                    self.lcNavigationController.pageType = PageTypeNorMal;
                }
                [self.lcNavigationController pushViewController:pvc];
                pvc.dataModel = datasModel;

            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleDestructive handler:NULL];
            [alert addAction:action1];
            [alert addAction:action2];
            [wSelf presentViewController:alert animated:YES completion:NULL];
        } else {
            PlayViewController *pvc = [PlayViewController sharePlayController];
            newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
            pvc.soundsArr = self.trelloListItem.rowItemsArray;
            pvc.index = indexPath.item;
            
            if (self.isLastPage) {
                self.lcNavigationController.pageType = PageTypeLastLast;
                self.lcNavigationController.isComment = NO;
            } else {
                self.lcNavigationController.pageType = PageTypeNorMal;
            }
            [self.lcNavigationController pushViewController:pvc];
            pvc.dataModel = datasModel;

        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    self.collectionView = nil;
    self.trelloListItem = nil;
    NSLog(@"%s", __func__);
}


@end
