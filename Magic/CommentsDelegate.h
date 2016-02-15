//
//  CommentsDelegate.h
//  Magic
//
//  Created by mxl on 16/1/10.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentsDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *headerView;

@end
