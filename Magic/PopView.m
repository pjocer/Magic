//
//  PopView.m
//  VisualFeast
//
//  Created by mxl on 15/12/29.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//

#import "PopView.h"
#import "UIView+Common.h"

@interface PopView ()

@property (nonatomic, strong) NSArray *setArr;

@end

#define COLOR [UIColor colorWithWhite:0.000 alpha:0.270]

@implementation PopView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR;
        _setArr = @[@"举报"];
        
        [self createBtn];
    }
    return self;
}

- (void)createBtn {
    
    for (NSString *str in _setArr) {
        static NSInteger i = 0;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, 50 * i ++, width(self), 50);
        btn.backgroundColor = [UIColor colorWithRed:0.243
                                              green:0.318
                                               blue:0.365
                                              alpha:1.000];
        btn.backgroundColor = COLOR;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        btn.tag = i;
        [btn addTarget:self action:@selector(setBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:str
             forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor]
                  forState:UIControlStateNormal];
        [self addSubview:btn];
    }
}

- (void)setBtnClick:(UIButton *)btn {
    NSInteger tag = btn.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(turnToSettingPage:)]) {
        [self.delegate turnToSettingPage:tag];
    }
}

@end
