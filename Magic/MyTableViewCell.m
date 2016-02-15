//
//  MyTableViewCell.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *authorLabel;

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [UIImageView new];
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.numberOfLines = 0;
        
        _iconView.userInteractionEnabled = YES;
        _nameLabel.userInteractionEnabled = YES;
        
        [self.contentView addSubview:_iconView];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconView.frame = CGRectMake(5, 5, (self.contentView.height - 10), self.contentView.height - 10);
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + 5, 5, self.contentView.width - CGRectGetMaxX(_iconView.frame) - 20, 40);
}

- (void)setDatasModel:(newDatasModel *)datasModel {
    _datasModel = datasModel;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:_datasModel.pic_1080] placeholderImage:nil];
    _nameLabel.text = _datasModel.name;
}

@end
