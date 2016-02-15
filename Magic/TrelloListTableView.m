//
//  TrelloListTableView.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/6.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "TrelloListTableView.h"

@implementation TrelloListTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style listItem:(TrelloListItem *)item {
    self = [super initWithFrame:frame style:style];
    if(self) {
        self.listItem = item;
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
@end
