//
//  TrelloListTableViewCell.m
//  SCTrelloNavigation
//
//  Created by Yh c on 15/11/6.
//  Copyright © 2015年 Yh c. All rights reserved.
//

#import "TrelloListTableViewCell.h"

@implementation TrelloListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, self.width - 20.0f, self.height - 5.0f)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 5.0f;
    [self.contentView addSubview:_bgView];
    
    self.detailImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _detailImageView.contentMode = UIViewContentModeScaleAspectFill;
    _detailImageView.layer.masksToBounds = YES;
    [self.bgView addSubview:_detailImageView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _contentLabel.textColor = Global_trelloLightGray;
    _contentLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.bgView addSubview:_contentLabel];
    
    self.colorIndicatorView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.bgView addSubview:_colorIndicatorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(10.0f, 5.0f, self.width - 20.0f, self.height - 5.0f);
   
    self.detailImageView.frame = CGRectMake(0.0f, 0.0f, self.bgView.width, self.height * 2.0 / 3.0);
    //self.detailImageView.image = self.item.image;
    [[SDImageCache sharedImageCache] clearMemory];
    [self.detailImageView sd_setImageWithURL:[NSURL URLWithString:self.item.pic_500] placeholderImage:nil];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    
    self.colorIndicatorView.frame = CGRectZero;
    self.contentLabel.frame = CGRectMake(15.0f, _detailImageView.bottom + 10.0f, self.bgView.width - 30.0f, 20.0f);
    self.contentLabel.text = self.item.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
