//
//  CommentsView.m
//  Magic
//
//  Created by mxl on 16/1/10.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "CommentsView.h"
#import "CommentsDelegate.h"
#import "LyricView.h"




@interface CommentsView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CommentsDelegate *comments;

@property (nonatomic, strong) DetailResult *resultModel;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

static NSString *const indentifier = @"indentifier";

@implementation CommentsView

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self loadInfoData];
}

- (void)loadInfoData {
    if (!_resultModel) {
        __weak typeof(self) wSelf = self;
        [self.manager GET:[NSString stringWithFormat:SOUND_DETAIL, _soundsID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            SoundsDetailModel *detailModel = [[SoundsDetailModel alloc] initWithData:responseObject error:nil ];
            _resultModel = detailModel.result;
            [wSelf createHeaderView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }
}

- (void)createHeaderView {
    
    UIImageView *bgImage = [UIImageView new];
    bgImage.frame = self.view.bounds;
    if (self.bgImage) {
        bgImage.image = self.bgImage;
    } else {
        [bgImage sd_setImageWithURL:[NSURL URLWithString:_resultModel.pic]
                   placeholderImage:nil];
    }
    [self.view addSubview:bgImage];
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
    [self.view addSubview:effectView];
    
    _headImage = [UIImageView new];
    _headImage.frame = CGRectMake(0, 0, self.view.width, self.view.height - CELL_HEIGHT * 5);
    if (self.bgImage) {
        _headImage.image = _bgImage;
    } else {
        [_headImage sd_setImageWithURL:[NSURL URLWithString:_resultModel.pic]
                      placeholderImage:nil];
    }
    [self.view addSubview:_headImage];
 
    self.gradientLayer = [CAGradientLayer layer];
    [_headImage.layer addSublayer:self.gradientLayer];
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(0, 1);
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor blackColor].CGColor];
    self.gradientLayer.locations = @[@(0.0f), @(0.5f)];
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, CGRectGetMaxY(_headImage.frame), self.view.width, CELL_HEIGHT * 5);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(self.view.width * 2, CELL_HEIGHT * 5);
    [self.view addSubview:_scrollView];
    
    [self createTableView];
    [self createLyricView];
}

- (void)createTableView {
    
    CGRect tableFrame = CGRectMake(0, 0, self.view.width, CELL_HEIGHT * 5);
    _tableView = [[UITableView alloc] initWithFrame:tableFrame];
    _comments = [[CommentsDelegate alloc] init];
    _tableView.dataSource = _comments;
    _tableView.delegate = _comments;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.scrollView addSubview:_tableView];
    [self refresh];
}

- (void)createLyricView {
    CGSize size = [self sizeWithText:_resultModel.info maxSize:CGSizeMake(self.view.width, 10000) fontSize:10];
    LyricView *lyric = [[LyricView alloc] init];
    lyric.lyricWord = _resultModel.info;
    lyric.backgroundColor = [UIColor clearColor];
    lyric.frame = CGRectMake(0, 0, self.view.width, size.height);
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.frame = CGRectMake(self.view.width, 0, self.view.width, CELL_HEIGHT * 5);
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.contentSize = CGSizeMake(size.width, size.height);
    scroll.alwaysBounceVertical = YES;
    [_scrollView addSubview:scroll];
    [scroll addSubview:lyric];
}

- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize{
    
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

- (void)refresh {
    __weak typeof(self) wSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wSelf loadComments:NO];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [wSelf loadComments:YES];
    }];
    self.tableView.mj_footer = footer;
    [self.tableView.mj_header beginRefreshing];
}



- (void)loadComments:(BOOL)isMore {
    BOOL isConnect = [XWBaseMethod connectionInternet];
    
    NSInteger page = 1;
    if (isMore) {
        if (_dataArray.count % 5 == 0) {
            page = _dataArray.count / 5 + 1;
        } else {
            return;
        }
    } else {
        [_dataArray removeAllObjects];
        [_tableView reloadData];
    }
    NSString *url = [NSString stringWithFormat:COMMENT_URL, page, _soundsID];
    
    if (!isConnect) {
        NSData *cacheData = [JWCache objectForKey:MD5Hash(url)];
        if (cacheData) {
            NewDataModel *dataModel = [[NewDataModel alloc] initWithData:cacheData error:nil];
            [_dataArray addObjectsFromArray:dataModel.result.detailData];
            _comments.dataArray = _dataArray;
            _comments.headerView = _scrollView;
            [_tableView reloadData];
            isMore ? [_tableView.mj_footer endRefreshing] : [_tableView.mj_header endRefreshing];
            return;
        }
    }
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NewDataModel *dataModel = [[NewDataModel alloc] initWithData:responseObject error:nil];
        [_dataArray addObjectsFromArray:dataModel.result.detailData];
        _comments.dataArray = _dataArray;
        [_tableView reloadData];
        [JWCache setObject:responseObject forKey:MD5Hash(url)];
        isMore ? [_tableView.mj_footer endRefreshing] : [_tableView.mj_header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.description);
        isMore ? [_tableView.mj_footer endRefreshing] : [_tableView.mj_header endRefreshing];
    }];
}



@end
