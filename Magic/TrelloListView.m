//
//  BtnTableViewCell.m
//  Magic
//
//  Created by mxl on 16/1/6.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "TrelloListView.h"

@implementation TrelloListView

- (id)initWithFrame:(CGRect)frame index:(NSInteger)index listArray:(NSArray *)listItems {
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;

        self.contentSize = CGSizeMake(listItems.count * (ScreenWidth - 45.0f), self.height);
        self.contentOffset = CGPointMake(0.0f, 0.0f);
        self.userInteractionEnabled = YES;
        self.pagingEnabled = YES;
        self.originTop = self.top;
        self.isFoldMode = YES;
        self.bouncesZoom = NO;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.reusableTableViewArray = [NSMutableArray array];
        self.visibleTableViewArray = [NSMutableArray array];
        self.currentIndex = index;
        
        self.listItems = [listItems mutableCopy];

        CGFloat nextX = 0.0f;
        //listItems.count
        for (NSInteger i = 0; i < listItems.count ; i++) {
            if (i == 0) {
 
                ListController1 *lc1 = [[ListController1 alloc] init];
                lc1.trelloListItem = listItems[i];
                lc1.view.frame = CGRectMake(nextX, 0.0f, ScreenWidth - 60.0f, self.height);
                lc1.trelloListTableView.dataSource = self;
                lc1.trelloListTableView.delegate = self;
                lc1.trelloListTableView.userInteractionEnabled = YES;
                [self addSubview:lc1.view];
                [self.visibleTableViewArray addObject:lc1];
                nextX = lc1.view.right + 15.0f;
                
            } else if (i == 1) {

                CollectionController1 *cvc1 = [[CollectionController1 alloc] init];
                cvc1.trelloListItem = listItems[i];
                cvc1.collectionView.userInteractionEnabled = YES;
                cvc1.view.frame = CGRectMake(0, 0.0f, ScreenWidth - 60.0f, self.height + 64 - 44);

                CollectionController2 *cvc2 = [[CollectionController2 alloc] init];
                cvc2.trelloListItem = listItems[i+1];
                cvc2.view.userInteractionEnabled = YES;
                cvc2.collectionView.userInteractionEnabled = YES;
                cvc2.view.frame = CGRectMake(nextX + 45, 0.0f, ScreenWidth - 60.0f, self.height + 64 - 44);

                PageViewController *pvc = [[PageViewController alloc] init];
                pvc.selfFrame = CGRectMake(nextX, 0.0f, ScreenWidth - 60.0f, self.height - 25);
                pvc.view.frame = CGRectMake(nextX, 0.0f, ScreenWidth - 60.0f, self.height - 25);

                [self addSubview:pvc.view];
                
#warning 不能传递 cvc.view ，传递view会导致视图点击出现问题
                pvc.cvc1 = cvc1;
                pvc.cvc2 = cvc2;
                [self.visibleTableViewArray addObject:pvc];
                nextX = pvc.view.right + 15.0f;

            } else if (i == 2) {
                ClassViewController *classV = [[ClassViewController alloc] init];
                classV.view.frame = CGRectMake(nextX, 0.0f, ScreenWidth - 60.0f, self.height + 70);
                [self addSubview:classV.view];
                [self.visibleTableViewArray addObject:classV];
                nextX = classV.view.right + 15.0f;
                
            }
        }
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(TrelloListTableView *)tableView listItem].rowItemsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrelloListTableView *t_tableView = (TrelloListTableView *)tableView;
    
    newDatasModel *t_item = [t_tableView.listItem.rowItemsArray objectAtIndex:indexPath.row];
    
    TrelloListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[TrelloListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.item = t_item;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (ScreenWidth - 60.0f) / 9.0 * 5.0;;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![XWBaseMethod connectionInternet]) {
        [XWBaseMethod showErrorWithStr:@"网络异常" toView:self];
        return;
    }
    [LGReachability LGwithSuccessBlock:^(NSString *status) {
        if ([status isEqualToString: @"3G/4G网络"] || [status isEqualToString: @"无连接"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"当前为移动网络,是否继续播放" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TrelloListTableView *t_tableView = (TrelloListTableView *)tableView;
                newDatasModel *t_item = [t_tableView.listItem.rowItemsArray objectAtIndex:indexPath.row];
                
                PlayViewController *pvc = [PlayViewController sharePlayController];
                
                AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                HomeViewController *hvc = (HomeViewController *)app.hvc;
                pvc.soundsArr = t_tableView.listItem.rowItemsArray;
                pvc.index = indexPath.row;
                
                hvc.lcNavigationController.pageType = PageTypeNorMal;
                [hvc.lcNavigationController pushViewController:pvc];
                
                pvc.dataModel = t_item;
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleDestructive handler:NULL];
            [alert addAction:action1];
            [alert addAction:action2];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.hvc presentViewController:alert animated:YES completion:NULL];
        } else {
            TrelloListTableView *t_tableView = (TrelloListTableView *)tableView;
            newDatasModel *t_item = [t_tableView.listItem.rowItemsArray objectAtIndex:indexPath.row];
            
            PlayViewController *pvc = [PlayViewController sharePlayController];
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            HomeViewController *hvc = (HomeViewController *)app.hvc;
            pvc.soundsArr = t_tableView.listItem.rowItemsArray;
            pvc.index = indexPath.row;
            
            hvc.lcNavigationController.pageType = PageTypeNorMal;
            [hvc.lcNavigationController pushViewController:pvc];
            
            pvc.dataModel = t_item;

        }
    }];
    
}

- (void)playMusic {
    
}


@end
