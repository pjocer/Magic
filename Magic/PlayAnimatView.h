//
//  PlayAnimatView.h
//  Magic
//
//  Created by mxl on 16/1/5.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayAnimatView : UIImageView

@property (nonatomic, assign) CGRect animatFrame;

@property (nonatomic, strong) NSMutableArray *animatImages;

+ (instancetype)sharePlayAnimatView;


@end
