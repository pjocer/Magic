//
//  HomeViewController.m
//  Magic
//
//  Created by mxl on 16/1/3.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation HomeViewController

#define TMP @"http://echosystem.kibey.com/user/info?android_v=85&app_channel=wandoujia&t=1452130856284&user_id=13858727&v=9"

- (void)viewDidLoad {
    [super viewDidLoad];

    _titleArr = @[@"推荐声音",
                  @"频道",
                  @"分类"];
    [self createBgImageView];
    self.view.backgroundColor = Global_trelloDeepBlue;
    
    [self initNaviBar];
//    [self.manager GET:TMP parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSLog(@"%@", dic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@", error.description);
//    }];

}

- (void)createBgImageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"002.jpg"];
    imageView.userInteractionEnabled = YES;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
    effectView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    [self.view addSubview:effectView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initNaviBar {
    
    self.trelloView = [[TrelloView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, ScreenWidth, ScreenHeight - 44) dataSource:self];
    [self.view addSubview:_trelloView];
}

- (NSInteger)numberForBoardsInTrelloView:(TrelloView *)trelloView {
    return _titleArr.count;
}

- (NSInteger)numberForRowsInTrelloView:(TrelloView *)trelloView atBoardIndex:(NSInteger)index {
    return 0;
}

- (newDatasModel *)itemForRowsInTrelloView:(TrelloView *)trelloView atBoardIndex:(NSInteger)index atRowIndex:(NSInteger)rowIndex {
    return nil;

}

- (NSString *)titleForBoardsInTrelloView:(TrelloView *)trelloView atBoardIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return _titleArr[0];
            break;
        case 1:
            return _titleArr[1];
            break;
        case 2:
            return _titleArr[2];
            break;
        default:
            break;
    }
    return @"热门";
}
/**
 *  头部高度
 */
- (SCTrelloBoardLevel)levelForRowsInTrelloView:(TrelloView *)trelloView atBoardIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            return SCTrelloBoardLevel4;
            break;
        case 3:
            return SCTrelloBoardLevel4;
            break;
        case 2:
            return SCTrelloBoardLevel3;
            break;
        case 4:
            return SCTrelloBoardLevel3;
            break;
        case 1:
            return SCTrelloBoardLevel5;
            break;
        default:
            return SCTrelloBoardLevel1;
            break;
    }
}

@end
