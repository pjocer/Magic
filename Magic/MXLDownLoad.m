//
//  MXLDownLoad.m
//  01-MXLDownloader
//
//  Created by PerryJump on 15/11/24.
//  Copyright © 2015年 XuLiangMa. All rights reserved.
//

#import "MXLDownLoad.h"
#import "NSString+Common.h"

//在这里写的这个interface相当于对MXLDownLoad类的扩展
@interface MXLDownLoad ()<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

//网络请求类
@property (nonatomic, copy)     NSURLConnection     *urlConnection;
@property (nonatomic, copy)     NSFileHandle        *fileHandle;
@property (nonatomic, copy)     NSString            *fileURL;           //文件下载总长度
@property (nonatomic, assign)   unsigned long long  fileOffSet;         //每次文件偏移量(当前已经下载的内容长度)
@property (nonatomic, assign)   unsigned long long  totalFileSize;      //文件总长度

@property (nonatomic, copy)     NSString            *tempPath;          //临时文件路径

@property (nonatomic, assign)   BOOL                overFile;           //如果文件已经存在是否允许覆盖

@property (nonatomic, copy)     DownLoadStart       startBlock;
@property (nonatomic, copy)     DownLoading         loadingBlock;
@property (nonatomic, copy)     DownLoadFinish      finishBlock;
@property (nonatomic, copy)     DownLoadFaild       faildBlock;


@property (nonatomic, weak)  id<MXLDownLoadDelegate>  delegate;

@end

@implementation MXLDownLoad

//以block的形式进行初始化
- (instancetype)initWithURL:(NSString *)downLoadURL startBlock:(DownLoadStart)starBlock
               loadingBlock:(DownLoading)loadingBlock finishBlock:(DownLoadFinish)finishBlock
                 faildBlock:(DownLoadFaild)faildBlock overFile:(BOOL)overFile{

    if (self = [super init]) {
        _fileURL = downLoadURL;
        
        _startBlock = starBlock;
        _loadingBlock = loadingBlock;
        _finishBlock = finishBlock ;
        _faildBlock = faildBlock;
        _overFile = overFile;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)downLoadURL delegate:(id<MXLDownLoadDelegate>)delegate overFile:(BOOL)overFile{

    if (self = [super init]) {
        _urlConnection = [[NSURLConnection alloc]init];
        _fileURL = [[NSString alloc]initWithString:downLoadURL];
        _delegate = delegate;
        _overFile = overFile;
    }
    return self ;
}

- (void)start{
    
    if (!_fileURL) {
        
        NSError *error = [NSError errorWithDomain:@"Download URL can not nil!" code:0 userInfo:nil];
        if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFaild:faildError:)]) {
            [_delegate downLoadDidFaild:self faildError:error];
        }
        if (_faildBlock) {
            _faildBlock(self, error);
        }
        
        return;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取沙盒的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *document = paths[0];
    //下载文件存放的路径
    NSString *targetPath = [NSString stringWithFormat:@"%@/%@", document, @"classes"];
    //判断路径是否存在
    if (![fileManager fileExistsAtPath:targetPath]) {
        
        NSLog(@"路径不存在，创建文件夹classes");
        //如果下载路径的文件夹不存在就创建它
        BOOL createDirectorySuc = [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!createDirectorySuc) {
            NSError *error = nil;
            error = [NSError errorWithDomain:@"Create Directory failed" code:1001 userInfo:nil];
            
            if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFaild:faildError:)]) {
                [_delegate downLoadDidFaild:self faildError:error];
            }else{
                return;
            }
            if (_faildBlock) {
                _faildBlock(self, error);
            }
        }
    }
    //获取文件后缀名
    NSString *fileExtension = [_fileURL pathExtension];
//    NSArray *tmpArr = [fileExtension componentsSeparatedByString:@"?"];
//    if (tmpArr.count > 1) {
//        fileExtension = tmpArr[0];
//    }
    //生成文件名,URL唯一,md5之后唯一
    NSString *fileName = [_fileURL MD5Hash];
    //生成文件的最终位置
    _destinationPath = [NSString stringWithFormat:@"%@/%@.%@", targetPath, fileName, fileExtension];
    
    if (self.isTest) {
        if ([fileManager fileExistsAtPath:_destinationPath]) {
            self.fileIsCreated = YES;
        } else {
            self.fileIsCreated = NO;
        }
        return;
    }
    
    if (_overFile) {
        if ([fileManager fileExistsAtPath:_destinationPath]) {
            BOOL deleteSuc = [fileManager removeItemAtPath:_destinationPath error:nil];
            if (deleteSuc) {
                NSLog(@"删除成功");
            }
        }
    }
    //如果目标文件路径存在将进度置为1.0
    if ([fileManager fileExistsAtPath:_destinationPath]) {
        
        
        _progress = 1.0;
        if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFinish:filePath:)]) {
            [_delegate downLoadDidFinish:self filePath:_destinationPath];
        }
        if (_finishBlock) {
            _finishBlock(self, _destinationPath);
        }
        if (_loadingBlock) {
            _loadingBlock(self, _progress);
        }
        if (_delegate && [_delegate respondsToSelector:@selector(downLoad:progressChanged:)]) {
            [_delegate downLoad:self progressChanged:1.0];
        }
        return;
    }
    //创建临时文件路径
    _tempPath = [NSString stringWithFormat:@"%@/%@", targetPath, [_fileURL MD5Hash]];
    //判断临时文件是否存在
    if (![fileManager fileExistsAtPath:_tempPath]) {
        //创建临时文件
        BOOL isTempFileSuc = [fileManager createFileAtPath:_tempPath contents:nil attributes:nil];
        if (!isTempFileSuc) {
             NSError *error = [NSError errorWithDomain:@"Create TempFile Faild" code:1002 userInfo:nil];
            if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFaild:faildError:)]) {
               
                [_delegate downLoadDidFaild:self faildError:error];
            }
            if (_faildBlock) {
                _faildBlock(self, error);
            }
            return;
        }
    }
    [_fileHandle closeFile];
    //根据临时文件路径创建文件句柄
    _fileHandle = [NSFileHandle fileHandleForWritingAtPath:_tempPath];
    //移动到文件末尾
    _fileOffSet = [_fileHandle seekToEndOfFile];
    //创建可变的request对象
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_fileURL]];
    //设置从哪里开始下载
    NSString *rang = [NSString stringWithFormat:@"bytes=%llu-", _fileOffSet];
    //给httprequest设置range
    [mutableRequest addValue:rang forHTTPHeaderField:@"Range"];
    _urlConnection = [[NSURLConnection alloc]initWithRequest:mutableRequest delegate:self startImmediately:YES];
}

#pragma mark - NSURLConnectionDelegate代理方法
/**
 *  文件开始下载代理(首包时间)
 *
 *  @param connection
 *  @param response
 */
- (void)connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response{
    if ([response expectedContentLength] != NSURLResponseUnknownLength) {
        //这个方法只会调用一次
        //expectedContentLength 每次需要下载的总长度
        //当再次下载的时候[response expectedContentLength]比第一次要少，所以加上偏移量使要下载的总长度_totalFileSize永远不变
        _totalFileSize = [response expectedContentLength] + _fileOffSet;
    }
    //开始下载
    if (_delegate && [_delegate respondsToSelector:@selector(downLoadStart:)]) {
        [_delegate downLoadStart:self];
    }
    if (_startBlock) {
        _startBlock(self);
    }
    
}
/**
 *  获取到文件的数据
 *
 *  @param connection
 *  @param data
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//文件io操作不断写入文件到本地
    [_fileHandle writeData:data];
    //每次写完之后将光标移动到最后(每次都是从最后开始写入)
     _fileOffSet = [_fileHandle offsetInFile];
    //实时计算文件的下载进度
    _progress = (double)_fileOffSet / _totalFileSize;
    
    if (_delegate && [_delegate respondsToSelector:@selector(downLoad:progressChanged:)]) {
        [_delegate downLoad:self progressChanged:_progress];
    }
    if (_loadingBlock) {
        _loadingBlock(self, _progress);
    }
       NSLog(@"%f", _progress);
}
/**
 *  下载完成
 *
 *  @param connection
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [_fileHandle closeFile];
    //移动临时文件到目标文件
    if ([[NSFileManager defaultManager] moveItemAtPath:_tempPath toPath:_destinationPath error:nil]) {
        //如果下载成功(成功将最后的文件移动到目标文件)
        if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFinish:filePath:)]) {
            [_delegate downLoadDidFinish:self filePath:_destinationPath];
        }
        if (_finishBlock) {
             _finishBlock(self, _destinationPath);
        }
    }
}
/**
 *  下载失败
 *
 *  @param connection
 *  @param error
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    if (_delegate && [_delegate respondsToSelector:@selector(downLoadDidFaild:faildError:)]) {
        [_delegate downLoadDidFaild:self faildError:error];
    }
    
    if (_faildBlock) {
        _faildBlock(self, error);
    }
}

- (void)stop{
    
    //取消下载数据(取消请求)
    [_urlConnection cancel];
    _urlConnection = nil;
    
    //关掉文件读写
    [_fileHandle closeFile];
    _fileHandle = nil;
}

- (void)clean{
    
    [self stop];
    
    [[NSFileManager defaultManager]removeItemAtPath:_tempPath error:nil];
    [[NSFileManager defaultManager]removeItemAtPath:_destinationPath error:nil];
}

@end
























