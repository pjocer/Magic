//
//  BtnTableViewCell.m
//  Magic
//
//  Created by mxl on 16/1/6.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "BtnTableViewCell.h"

@interface BtnTableViewCell ()

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *hotBtn;

@end

@implementation BtnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _btn = [UIButton new];
        [_btn setSelected:YES];
        [_btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"最新频道" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        _hotBtn = [UIButton new];
        [_hotBtn addTarget:self action:@selector(hotClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hotBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_hotBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_hotBtn setTitle:@"最热频道" forState:UIControlStateNormal];
        [self.contentView addSubview:_hotBtn];
        [self.contentView addSubview:_btn];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    [_hotBtn setSelected:NO];
    [_btn setSelected:YES];
    if (self.pageBlock) {
        self.pageBlock(YES);
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(pageBtnClick:)]) {
//        [self.delegate pageBtnClick:YES];
//    }
}

- (void)hotClick:(UIButton *)btn {
    [_btn setSelected:NO];
    [_hotBtn setSelected:YES];
    if (self.pageBlock) {
        self.pageBlock(NO);
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(pageBtnClick:)]) {
//        [self.delegate pageBtnClick:NO];
//    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _btn.frame = CGRectMake(0, 5, 100, 30);
    CGFloat hotX = CGRectGetMaxX(_btn.frame);
    _hotBtn.frame = CGRectMake(hotX, 5, 100, 30);
}


@end
