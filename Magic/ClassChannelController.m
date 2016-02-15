//
//  ClassChannelController.m
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ClassChannelController.h"

@interface ClassChannelController ()

@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation ClassChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = Global_trelloGray;
    self.effectView.hidden = NO;
    [self.trelloListItem.rowItemsArray removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createTopView {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake((ScreenWidth - 60 - 100) / 2, 3, 100, 27);
    _nameLabel.text = _className;
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = TITLE_COLOR;
    [self.view addSubview:_nameLabel];
}

- (void)setClassName:(NSString *)className {
    _className = className;
    _nameLabel.text = _className;
}

- (void)createDownloadUrl {
    
    self.downLoadUrl = [NSString stringWithFormat:@"%@%@", CLASS , _classUrl];;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ChannelViewController *cvc = [ChannelViewController new];
    newDatasModel *datasModel = self.trelloListItem.rowItemsArray[indexPath.item];
    cvc.channelID = datasModel.id;
    self.lcNavigationController.pageType = PageTypeLastSec;
    cvc.isLastPage = YES;
    [self.lcNavigationController pushViewController:cvc];
}

@end
