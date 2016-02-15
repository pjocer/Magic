//
//  PopView.h
//  VisualFeast
//
//  Created by mxl on 15/12/29.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingProtocol <NSObject>

- (void)turnToSettingPage:(NSInteger)btnTag;

@end

@interface PopView : UIView

@property (nonatomic, weak) id<SettingProtocol> delegate;

@end
