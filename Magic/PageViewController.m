//
//  PageViewController.m
//  Magic
//
//  Created by mxl on 16/1/6.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "PageViewController.h"

@interface PageViewController ()<UITableViewDataSource, UITableViewDelegate, PageProtocol>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *hotBtn;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMagicBg];
//    self.view.backgroundColor = [UIColor redColor];
    [self createScrollView];
//    [self createTableView];
    [self createMask];
    
    [self createTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)createMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.selfFrame.size.width, self.selfFrame.size.height)
                                                   byRoundingCorners:
                              UIRectCornerTopLeft |
                              UIRectCornerTopRight |
                              UIRectCornerBottomLeft |
                              UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, self.selfFrame.size.width, self.selfFrame.size.height);
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

- (void)createMagicBg {

    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = CGRectMake(0, 0, self.selfFrame.size.width, self.selfFrame.size.height);
    effectView.userInteractionEnabled = YES;

    [self.view addSubview:effectView];
}

- (void)createTopView {

    CGRect frame = CGRectMake(0, 0, ScreenWidth - 60.0f, 44);
    TopTitleView *topView = [[TopTitleView alloc] initWithFrame:frame];
    topView.topTitle = @"";
    [self.view addSubview:topView];
    
    _firstBtn = [UIButton new];
    _firstBtn.frame = CGRectMake(0, 5, 100, 30);
    [_firstBtn setTitle:@"最新频道"
               forState:UIControlStateNormal];
    [_firstBtn setTitleColor:[UIColor blackColor]
                    forState:UIControlStateNormal];
    [_firstBtn setTitleColor:[UIColor redColor]
                    forState:UIControlStateSelected];
    [_firstBtn addTarget:self
                  action:@selector(newClick:)
        forControlEvents:UIControlEventTouchUpInside];
    [_firstBtn setSelected:YES];
    [self.view addSubview:_firstBtn];
    
    _hotBtn = [UIButton new];
    CGFloat hotX = CGRectGetMaxX(_firstBtn.frame) + 5;
    _hotBtn.frame = CGRectMake(hotX, 5, 100, 30);
    [_hotBtn setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    [_hotBtn setTitleColor:[UIColor redColor]
                  forState:UIControlStateSelected];
    [_hotBtn setTitle:@"最热频道" forState:UIControlStateNormal];
    [_hotBtn addTarget:self
                action:@selector(hotClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_hotBtn];
}

- (void)newClick:(UIButton *)btn {
    [_hotBtn setSelected:NO];
    [_firstBtn setSelected:YES];
    [_scrollView setContentOffset:CGPointMake(0, 0)
                         animated:YES];
}

- (void)hotClick:(UIButton *)btn {
    [_hotBtn setSelected:YES];
    [_firstBtn setSelected:NO];
    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)
                         animated:YES];
}

- (void)createScrollView {
    _scrollView = [UIScrollView new];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth - 60, self.view.height - 105);
    _scrollView.userInteractionEnabled = YES;
    _scrollView.contentSize = CGSizeMake(2 * (ScreenWidth - 60), 0);
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
}

- (void)setCvc1:(CollectionController1 *)cvc1 {
    _cvc1 = cvc1;
    _cvc1.effectView.hidden = YES;
    [_scrollView addSubview:_cvc1.view];
}

- (void)setCvc2:(CollectionController2 *)cvc2 {
    _cvc2 = cvc2;
    _cvc2.effectView.hidden = YES;
    [_scrollView addSubview:_cvc2.view];
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 60.0f, 44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    
}

#pragma mark - UITableView代理方法

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *indentifier = @"indentifierr";
    BtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[BtnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = Global_trelloGray;
    /**
     *  下边为什么不能用 __weak self 只有用 self 或者下滑线才可以
     */
//    __weak typeof(self) weakSelf = self;
    
    
    cell.pageBlock = ^(BOOL isLeft){
        if (!isLeft) {
            [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        }else {
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    };
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)pageBtnClick:(BOOL)isLeft {
    if (isLeft) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
}

- (void)test {
    NSLog(@"1");
}



@end
