//
//  CollectionController1.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "CollectionController1.h"

@interface CollectionController1 ()<UICollectionViewDelegate>

@end

@implementation CollectionController1

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTopView {
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelViewController *cvc = [ChannelViewController new];
    newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
    cvc.channelID = datasModel.id;
    cvc.isLastPage = NO;
    self.lcNavigationController.pageType = PageTypeNorMal;
    [self.lcNavigationController pushViewController:cvc];
}

@end
