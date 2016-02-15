//
//  TopTitleView.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "TopTitleView.h"

@interface TopTitleView ()

@property (nonatomic, strong) UILabel *titleL;

@end

@implementation TopTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = Global_trelloGray;
        _titleL = [UILabel new];
        _titleL.userInteractionEnabled = YES;
        _titleL.frame = CGRectMake(10, 10, 100, 24);
        _titleL.textColor = TITLE_COLOR;
        [self addSubview:_titleL];
        [self createMask];
    }
    return self;
}

- (void)createMask {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.frame
                                                   byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                         cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.frame;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setTopTitle:(NSString *)topTitle {
    _topTitle = topTitle;
    _titleL.text = _topTitle;
}

@end
