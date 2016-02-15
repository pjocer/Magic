//
//  CommentsTableViewCell.m
//  Magic
//
//  Created by mxl on 16/1/10.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "CommentsTableViewCell.h"

@interface CommentsTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *upBtn;

@property (nonatomic, strong) NSUserDefaults *ud;

@end

@implementation CommentsTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _ud = [NSUserDefaults standardUserDefaults];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _iconImage = [UIImageView new];
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _detailLabel = [UILabel new];
    _detailLabel.numberOfLines = 0;
    _detailLabel.font = [UIFont systemFontOfSize:12];
    _detailLabel.textColor = [UIColor colorWithWhite:0.000 alpha:0.820];
    _upBtn = [UIButton new];
    
    [self.contentView addSubview:_iconImage];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_detailLabel];
    [self.contentView addSubview:_upBtn];
    
    UIImage *upNor = [UIImage imageNamed:@"ic_zan_gray_small"];
    UIImage *upSel = [UIImage imageNamed:@"ic_zan_green_small"];
    [_upBtn addTarget:self
               action:@selector(upClick:)
     forControlEvents:UIControlEventTouchUpInside];
    [_upBtn setBackgroundImage:upNor
                      forState:UIControlStateNormal];
    [_upBtn setBackgroundImage:upSel
                      forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _iconImage.frame = CGRectMake(5,
                                  5,
                                  self.contentView.height - 10,
                                  self.contentView.height - 10);
    _iconImage.clipsToBounds = YES;
    _iconImage.layer.cornerRadius = (self.contentView.height - 10) / 2;
    
    CGFloat nameX = CGRectGetMaxX(_iconImage.frame) + 5;
    _nameLabel.frame = CGRectMake(nameX, 5, 100, 20);

    _detailLabel.frame = CGRectMake(nameX,
                                    20,
                                    self.contentView.width - _iconImage.frame.size.width,
                                    self.contentView.size.height - _nameLabel.frame.size.height);
    _upBtn.frame = CGRectMake(self.contentView.width - 40,
                              7,
                              15,
                              15);
    
}

- (void)setDataModel:(newDatasModel *)dataModel {
    _dataModel = dataModel;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:_dataModel.user.avatar]
                  placeholderImage:nil];
    _nameLabel.text = _dataModel.user.name;
    _detailLabel.text = _dataModel.original_content;
    
    BOOL isClick = [_ud boolForKey:MD5Hash(_dataModel.user.name)];
    [_upBtn setSelected:isClick];
}

- (void)upClick:(UIButton *)btn {
    BOOL isClick = [_ud boolForKey:MD5Hash(_dataModel.user.name)];
    
    [btn setSelected:!isClick];

    [_ud setBool:!isClick forKey:MD5Hash(_dataModel.user.name)];
}

@end
