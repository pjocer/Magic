//
//  ClassTableViewCell.h
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassModel;

@interface ClassTableViewCell : UITableViewCell

@property (nonatomic, strong) ClassModel *model;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *nameLabel;

+ (instancetype)customClassTableView:(UITableView *)tableView;

@end
