//
//  MyCollectionViewCell.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "MyCollectionViewCell.h"

@interface MyCollectionViewCell ()

@property (nonatomic, strong) UILabel *shawLabel;


@end

@implementation MyCollectionViewCell

- (void)awakeFromNib {
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _shawLabel = [UILabel new];
        _shawLabel.backgroundColor = [UIColor colorWithRed:0.052 green:0.122 blue:0.118 alpha:0.640];
        _shawLabel.textAlignment = NSTextAlignmentLeft;
        _shawLabel.textColor = Global_trelloGray;
        _shawLabel.font = [UIFont systemFontOfSize:10];
        
        [self addSubview:_shawLabel];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    NSLog(@"111");
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _shawLabel.frame = CGRectMake(0, self.height - 30, self.width, 30);
}

- (void)setDatasModel:(newDatasModel *)datasModel {
    _datasModel = datasModel;
    
    _shawLabel.text = _datasModel.name;
}


@end
