//
//  BottomCustomView.h
//  Magic
//
//  Created by mxl on 16/1/8.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef enum : NSUInteger {
//    LoveBtnClick,
//    DownBtnClick,
//    ShareBtnClick,
//    SingBtnClick,
//    CommenBtnClick,
//} ClickBtnType;

@class BottomCustomView;

@protocol BottomCustomProtocol <NSObject>

- (void)bottomCustomBtnClick:(ClickBtnType)type bottomCustomView:(BottomCustomView *)bottomCustomView;

@end

@interface BottomCustomView : UIView

@property (nonatomic, strong) UIButton *loveBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIButton *singeBtn;
@property (nonatomic, strong) UIButton *commenBtn;
@property (nonatomic, strong) UIImageView *downingView;
@property (nonatomic, weak) id<BottomCustomProtocol> delegate;

- (void)refreshBtnState:(BOOL)isExist;

- (void)refreshDownState:(BOOL)isDowned;

- (void)refreshSingState:(BOOL)isSingle;

@end
