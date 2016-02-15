//
//  CollectionController2.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "CollectionController2.h"

@interface CollectionController2 ()

@end

@implementation CollectionController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createTopView {
//    CGRect frame = CGRectMake(0, 0, ScreenWidth - 60.0f, 44);
//    TopTitleView *topView = [[TopTitleView alloc] initWithFrame:frame];
//    topView.topTitle = @"最新频道";
//    [self.view addSubview:topView];
}



- (void)createDownloadUrl {
    
    self.downLoadUrl = HOT_URL;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"%ld", indexPath.item);
    ChannelViewController *cvc = [ChannelViewController new];
    newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
    cvc.channelID = datasModel.id;
    cvc.isLastPage = NO;
//    self.lcNavigationController.isLastPage = NO;
    self.lcNavigationController.pageType = PageTypeNorMal;
    [self.lcNavigationController pushViewController:cvc];
    //    [self.navigationController pushViewController:cvc animated:YES];
}


@end
