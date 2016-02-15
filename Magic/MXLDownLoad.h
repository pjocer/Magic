//
//  MXLDownLoad.h
//  01-MXLDownloader
//
//  Created by PerryJump on 15/11/24.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MXLDownLoad;

/**
 *  block方式
 *
 *  @param downLoad
 */
typedef void(^DownLoadStart)(MXLDownLoad *downLoad);
typedef void(^DownLoading)(MXLDownLoad *downLoad, double progressValue);
typedef void(^DownLoadFinish) (MXLDownLoad *downLoad, NSString *filePath);
typedef void(^DownLoadFaild) (MXLDownLoad *downLoad, NSError *faildError);

@protocol MXLDownLoadDelegate <NSObject>

@optional

- (void)downLoadStart:(MXLDownLoad *)downLoad;

- (void)downLoad:(MXLDownLoad *)downLoad progressChanged:(double)progressValue;

- (void)downLoadDidFinish:(MXLDownLoad *)downLoad filePath:(NSString *)filePath;

- (void)downLoadDidFaild:(MXLDownLoad *)downLoad faildError:(NSError *)faildError;

@end

@interface MXLDownLoad : NSObject
/**
 *  下载进度
 */
@property (nonatomic, assign)   double  progress;

// 测试文件是否存在
@property (nonatomic, assign) BOOL isTest;
// isTest为真是测试文件路径
@property (nonatomic, assign) BOOL fileIsCreated;

@property (nonatomic, copy)     NSString            *destinationPath;   //最终文件路径

//以block形式初始化
- (instancetype)initWithURL:(NSString *)downLoadURL
                 startBlock:(DownLoadStart)starBlock
               loadingBlock:(DownLoading)loadingBlock
                finishBlock:(DownLoadFinish)finishBlock
                 faildBlock:(DownLoadFaild)faildBlock
                   overFile:(BOOL)overFile;

- (instancetype)initWithURL:(NSString *)downLoadURL//下载地址
                   delegate:(id<MXLDownLoadDelegate>)delegate
                   overFile:(BOOL)overFile;//是否覆盖文件

- (void)start;

- (void)stop;

- (void)clean;

@end
