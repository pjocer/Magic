//
//  PlayViewController.h
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STKAudioPlayer;
@class SoundsDatasModel;

typedef enum : NSUInteger {
    SoundsTypeTableView,
    SoundsTypeCollection,
} SoundsFromtype;


@interface PlayViewController : UIViewController
/**
 *  播放数据源
 */
@property (nonatomic, strong) newDatasModel *dataModel;
@property (nonatomic, strong) SoundsDatasModel *soundsModel;
@property (nonatomic, assign) SoundsFromtype *soundsType;

@property (nonatomic, strong) STKAudioPlayer *player;
/**
 *  播放数据源数组
 */
@property (nonatomic, strong) NSMutableArray *soundsArr;

@property (nonatomic, assign) NSInteger index;

+ (instancetype)sharePlayController;




@end
