//
//  ClassTableViewCell.m
//  Magic
//
//  Created by mxl on 16/1/7.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "ClassTableViewCell.h"

NSString *const reusedIndentifier = @"cellID";

@interface ClassTableViewCell ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation ClassTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)customClassTableView:(UITableView *)tableView {
    ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedIndentifier];
    if (cell == nil) {
        cell = [[ClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedIndentifier];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.080];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _iconImageView = [UIImageView new];
    _iconImageView.clipsToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    
    self.gradientLayer = [CAGradientLayer layer];
    [_iconImageView.layer addSublayer:self.gradientLayer];
    
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    
    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
                                  (__bridge id)[UIColor colorWithRed:0.084 green:0.301 blue:0.442 alpha:1.000].CGColor];
    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:self.nameLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImageView.frame = CGRectMake(0, 3, self.contentView.width - 0, self.contentView.height - 6);
    self.gradientLayer.frame = _iconImageView.bounds;
    
    self.nameLabel.frame = CGRectMake(self.contentView.width / 2 + 40, self.contentView.height / 2 - 6, 100, 30);
}

- (void)setModel:(ClassModel *)model {
    _model = model;
    _iconImageView.image = [UIImage imageNamed:@"CellImage001"];
}

@end
