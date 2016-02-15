//
//  PlayBottomController.h
//  Magic
//
//  Created by mxl on 16/1/5.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    NextSounds,
//    LastSounds,
//} LastOrNext;

typedef void(^SliderBlock)  (float changeValue);
typedef void(^PlayBlock)    (void);
typedef void(^NextOrLastBlock)(LastOrNext LastOrNext);

@class BottomCustomView;

@protocol BottomProtocol <NSObject>

- (void)bottomBtnProtocol:(ClickBtnType)type bottomView:(BottomCustomView *)playBottomView;

@end

@interface PlayBottomController : UIView

@property (nonatomic, strong) UISlider *progressSlider;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *totalTime;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UIButton *lastBtn;
@property (nonatomic, strong) BottomCustomView *bottomCustom;


@property (nonatomic, copy) SliderBlock sliderBlock;
@property (nonatomic, copy) PlayBlock playBlock;
@property (nonatomic, copy) NextOrLastBlock nextOrLastBlock;

@property (nonatomic, weak) id<BottomProtocol> delegate;

@end
