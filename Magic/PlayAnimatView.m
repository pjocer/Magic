//
//  PlayAnimatView.m
//  Magic
//
//  Created by mxl on 16/1/5.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "PlayAnimatView.h"

@interface PlayAnimatView ()


@end

@implementation PlayAnimatView

+ (instancetype)sharePlayAnimatView {
    static PlayAnimatView *animat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animat = [[PlayAnimatView alloc] init];
    });
    return animat;
}

- (NSArray *)createAnimateImages {
    
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 6; i++) {
        NSString *imgName = [NSString stringWithFormat:@"music%ld", i];
        UIImage *image = [UIImage imageNamed:imgName];
        [tmpArr addObject:image];
    }
    return tmpArr;
}

- (NSArray<UIImage *> *)animationImages {
    if (_animatImages == nil) {
        _animatImages = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 6; i++) {
            NSString *imgName = [NSString stringWithFormat:@"music%ld", i+1];
            UIImage *image = [UIImage imageNamed:imgName];
            [_animatImages addObject:image];
        }
    }
    return _animatImages;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)setAnimatFrame:(CGRect)animatFrame {
    _animatFrame = animatFrame;
    self.frame = animatFrame;
    self.animationDuration = 0.8;
    self.animationImages = self.animationImages;
    self.image = self.animatImages[0];
    self.animationRepeatCount = 0;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    HomeViewController *hvc = app.hvc;
    
    PlayViewController *pvc = [PlayViewController sharePlayController];

    hvc.lcNavigationController.pageType = PageTypeNorMal;
    [hvc.lcNavigationController pushViewController:pvc];
}

@end
