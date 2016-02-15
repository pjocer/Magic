//
//  BottomCustomView.m
//  Magic
//
//  Created by mxl on 16/1/8.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "BottomCustomView.h"
#import "UIView+Common.h"

@implementation BottomCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat leftPadding = self.width / 8.7;
    CGFloat padding = 30;
    
    CGFloat padW = (self.width - 7.0f * padding) / 6.0f;
    CGFloat btnW = padW / 1.2;
    _loveBtn.frame = CGRectMake(leftPadding, 10, btnW, btnW);
    _downBtn.frame = CGRectMake(maxX(_loveBtn) + leftPadding, 10, btnW, btnW);
    
    _shareBtn.frame = CGRectMake(maxX(_downBtn) + leftPadding, 10, btnW, btnW);
    _singeBtn.frame = CGRectMake(maxX(_shareBtn) + leftPadding, 5, btnW + 13, btnW + 13);
    _commenBtn.frame = CGRectMake(maxX(_singeBtn) + leftPadding, 10, btnW, btnW);
    _downingView.frame = _downBtn.frame;
}

- (void)initSubViews {
    
    UIImage *loveNor = [[UIImage imageNamed:@"love_btn_normal@2x"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *loveSel = [[UIImage imageNamed:@"love_btn_select@2x"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *downNor = [[UIImage imageNamed:@"actionIconDownload_h_b@2x"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *downSel = [[UIImage imageNamed:@"actionIconDownloaded_h_b@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *shareNor = [[UIImage imageNamed:@"actionIconShare_h_b@2x"]
                         imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *singSel = [[UIImage imageNamed:@"repeatone_normal@2x"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *singNor = [[UIImage imageNamed:@"miniplayer_btn_repeat_normal_b@2x"]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *commenImg = [[UIImage imageNamed:
                           //@"bannertips_warning@2x"
                           @"actionIconComment_h_b@2x"
                           ]
                        imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    _loveBtn = [UIButton new];
    _downBtn = [UIButton new];
    _shareBtn = [UIButton new];
    _singeBtn = [UIButton new];
    _commenBtn = [UIButton new];
    _downingView = [UIImageView new];

    _loveBtn.backgroundColor = [UIColor clearColor];
    _downBtn.backgroundColor = [UIColor clearColor];
    _shareBtn.backgroundColor = [UIColor clearColor];
    _singeBtn.backgroundColor = [UIColor clearColor];
    _commenBtn.backgroundColor = [UIColor clearColor];
    _downingView.backgroundColor = [UIColor clearColor];
    
    [_loveBtn setBackgroundImage:loveNor
                        forState:UIControlStateNormal];
    [_loveBtn setBackgroundImage:loveSel
                        forState:UIControlStateSelected];
    [_loveBtn addTarget:self
                 action:@selector(loveClick:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [_downBtn setBackgroundImage:downNor
                        forState:UIControlStateNormal];
    [_downBtn setBackgroundImage:downSel
                        forState:UIControlStateSelected];
    [_downBtn addTarget:self
                 action:@selector(downClick:)
       forControlEvents:UIControlEventTouchUpInside];
    
    [_shareBtn setBackgroundImage:shareNor
                         forState:UIControlStateNormal];
    [_shareBtn addTarget:self
                  action:@selector(shareClick:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_singeBtn setBackgroundImage:singNor forState:UIControlStateNormal];
    [_singeBtn setBackgroundImage:singSel forState:UIControlStateSelected];
    [_singeBtn addTarget:self
                  action:@selector(singClick:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [_commenBtn setBackgroundImage:commenImg
                          forState:UIControlStateNormal];
    [_commenBtn addTarget:self
                   action:@selector(comClick:)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    _downingView.animationDuration = 0.2;
    UIImage *image1 = [UIImage imageNamed:@"icon_downing_pressed@2x"];
    UIImage *image2 = [UIImage imageNamed:@"icon_downing@2x"];
    _downingView.animationImages = @[image1, image2];
    _downingView.animationRepeatCount = 0;
    
    [self addSubview:_loveBtn];
    [self addSubview:_downBtn];
    [self addSubview:_shareBtn];
    [self addSubview:_singeBtn];
    [self addSubview:_commenBtn];
    [self addSubview:_downingView];
    [_downingView setHidden:YES];
}

- (void)refreshBtnState:(BOOL)isExist {
    [_loveBtn setSelected:isExist];
}

- (void)refreshDownState:(BOOL)isDowned {
    [_downBtn setSelected:isDowned];
}

- (void)refreshSingState:(BOOL)isSingle {
    [_singeBtn setSelected:isSingle];
}

- (void)loveClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomCustomBtnClick:bottomCustomView:)]) {
        [self.delegate bottomCustomBtnClick:LoveBtnClick bottomCustomView:self];
    }
}

- (void)downClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomCustomBtnClick:bottomCustomView:)]) {
        [self.delegate bottomCustomBtnClick:DownBtnClick bottomCustomView:self];
    }
}

- (void)shareClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomCustomBtnClick:bottomCustomView:)]) {
        [self.delegate bottomCustomBtnClick:ShareBtnClick bottomCustomView:self];
    }
}

- (void)singClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomCustomBtnClick: bottomCustomView:)]) {
        [self.delegate bottomCustomBtnClick:SingBtnClick bottomCustomView:self];
    }
}

- (void)comClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomCustomBtnClick:bottomCustomView:)]) {
        [self.delegate bottomCustomBtnClick:CommenBtnClick bottomCustomView:self];
    }
}

@end
