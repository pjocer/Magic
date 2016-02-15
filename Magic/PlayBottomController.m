//
//  PlayBottomController.m
//  Magic
//
//  Created by mxl on 16/1/5.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "PlayBottomController.h"

@interface PlayBottomController ()<BottomCustomProtocol>

@end

@implementation PlayBottomController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _progressSlider = [UISlider new];
    _progressSlider.minimumTrackTintColor = [UIColor colorWithWhite:0.000 alpha:0.510];
    _progressSlider.maximumTrackTintColor = [UIColor whiteColor];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"slider_thumb2"]
                          forState:UIControlStateNormal];
    [_progressSlider addTarget:self action:@selector(progressSlider:)
              forControlEvents:UIControlEventValueChanged];
    [self addSubview:_progressSlider];
    
    _timeLabel = [UILabel new];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_timeLabel];
    
    _totalTime = [UILabel new];
    _totalTime.backgroundColor = [UIColor clearColor];
    _totalTime.textColor = [UIColor whiteColor];
    _totalTime.font = [UIFont systemFontOfSize:15];
    _totalTime.textAlignment = NSTextAlignmentRight;
    [self addSubview:_totalTime];
    
    _playBtn = [UIButton new];
    _playBtn.backgroundColor = [UIColor clearColor];
    UIImage *btnImgNor = [UIImage imageNamed:@"ic_player_play"];
    UIImage *btnImgSel = [UIImage imageNamed:@"ic_player_pause"];
    [_playBtn setBackgroundImage:btnImgSel forState:UIControlStateNormal];
    [_playBtn setBackgroundImage:btnImgNor forState:UIControlStateSelected];
    [_playBtn addTarget:self
                 action:@selector(playBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    _lastBtn = [UIButton new];
    _lastBtn.backgroundColor = [UIColor clearColor];
    UIImage *lastImg = [UIImage imageNamed:@"ic_player_prev"];
    [_lastBtn setBackgroundImage:lastImg forState:UIControlStateNormal];
    [_lastBtn addTarget:self
                 action:@selector(lastBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_lastBtn];
    
    _nextBtn = [UIButton new];
    _nextBtn.backgroundColor = [UIColor clearColor];
    UIImage *nextImg = [UIImage imageNamed:@"ic_player_next"];
    [_nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [_nextBtn addTarget:self
                 action:@selector(nextBtnClick:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextBtn];
    
    CGRect customFrame = CGRectMake(0, self.height - 60, self.width, 60);
    _bottomCustom = [[BottomCustomView alloc] initWithFrame:customFrame];
    _bottomCustom.delegate = self;
    [self addSubview:_bottomCustom];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect sliderFrame = CGRectMake(20, 30, self.width - 40, 3);
    _progressSlider.frame = sliderFrame;
    _timeLabel.frame = CGRectMake(20, 35, 100, 30);
    _totalTime.frame = CGRectMake(self.width - 40 - 80, 35, 100, 30);
    
    CGFloat playW = 35;
    CGFloat playH = 35;
    CGFloat playX = self.width / 2 - playW / 2;
    CGFloat playY = CGRectGetMaxY(_totalTime.frame) + 13;
    _playBtn.frame = CGRectMake(playX, playY, playW, playH);
    _lastBtn.frame = CGRectMake(50, playY + 2.5, 30, 30);
    _nextBtn.frame = CGRectMake(self.width - 50 - 30, playY + 2.5, 30, 30);
}

- (void)progressSlider:(UISlider *)slider {
    if (self.sliderBlock) {
        self.sliderBlock(slider.value);
    }
}

- (void)playBtnClick:(UIButton *)btn {
    if (self.playBlock) {
        self.playBlock();
    }
}

- (void)lastBtnClick:(UIButton *)btn {
    if (self.nextOrLastBlock) {
        self.nextOrLastBlock(LastSounds);
    }
}

- (void)nextBtnClick:(UIButton *)btn {
    if (self.nextOrLastBlock) {
        self.nextOrLastBlock(NextSounds);
    }
}

- (void)bottomCustomBtnClick:(ClickBtnType)type bottomCustomView:(BottomCustomView *)bottomCustomView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomBtnProtocol:bottomView:)]) {
        [self.delegate bottomBtnProtocol:type bottomView:bottomCustomView];
    }
}


@end
