//
//  PlayViewController.m
//  Magic
//
//  Created by mxl on 16/1/4.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "PlayViewController.h"
#import "MXLDownLoad.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UMSocial.h"

@interface PlayViewController ()<STKAudioPlayerDelegate, BottomProtocol, NSURLSessionDataDelegate, SettingProtocol, UMSocialUIDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) STKDataSource *dataSource;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger durMin;
@property (nonatomic, assign) NSInteger durSec;
@property (nonatomic, strong) CABasicAnimation *basicAnimation;
@property (nonatomic, strong) PlayBottomController *bottomView;
@property (nonatomic, assign) CGFloat playW;
@property (nonatomic, strong) UILabel *soundsName;
@property (nonatomic, strong) MXLDownLoad *downLoad;
@property (nonatomic, assign) BOOL isSingle;
@property (nonatomic, strong) PopView *popView;

@end


@implementation PlayViewController

+ (instancetype)sharePlayController {
    static PlayViewController *pvc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pvc = [[PlayViewController alloc] init];
    });
    return pvc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _playW = ScreenWidth / 2.0 * 1.4;
    [self initSubviews];
    self.player = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    self.player.delegate = self;
    self.player.volume = 0.5;
    /**
     *  旋转图片
     */
    self.imageView = [[UIImageView alloc] init];
    self.imageView.backgroundColor = [UIColor clearColor];
    
    self.imageView.frame = CGRectMake(0, 0, _playW, _playW);
    self.imageView.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 3 + 20);
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    [self.view addSubview:self.imageView];
    
}

- (void)initSubviews {
    
    CGRect frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = frame;
    
    _bgImageView = [UIImageView new];
    _bgImageView.frame = frame;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgImageView];
    [self.view addSubview:effectView];
    
#define BTN_ALPHA   0.130
    
    UIView *topShaw = [UIView new];
    topShaw.frame = CGRectMake(0, 0, ScreenWidth, 57);
    topShaw.userInteractionEnabled = YES;
    topShaw.backgroundColor = [UIColor colorWithRed:0.933 green:0.982 blue:0.946 alpha:0.170];
    [self.view addSubview:topShaw];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImg = [UIImage imageNamed:@"lyric_up2@2x"];
    backBtn.backgroundColor = [UIColor colorWithWhite:0.000 alpha:BTN_ALPHA + 0.03];
    backBtn.frame = CGRectMake(10, 24, 27, 27);
    backBtn.layer.cornerRadius = backBtn.width / 2;
    [backBtn setBackgroundImage:backImg forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topShaw addSubview:backBtn];
    
    
    _soundsName = [UILabel new];
    _soundsName.frame = CGRectMake((ScreenWidth - 150) / 2, 23, 150, 27);
    _soundsName.textColor = [UIColor whiteColor];
    _soundsName.textAlignment = NSTextAlignmentCenter;
    _soundsName.font = [UIFont systemFontOfSize:17];
    [topShaw addSubview:_soundsName];
    
    UIImage *moreImg = [UIImage imageNamed:@"allMusic_more@2x"];
    UIButton *moreBtn = [UIButton new];
    moreBtn.frame = CGRectMake(ScreenWidth - 50, 19, 40, 40);
    moreBtn.transform = CGAffineTransformMakeRotation(M_PI_2);
    [moreBtn setBackgroundImage:moreImg
                       forState:UIControlStateNormal];
    [moreBtn addTarget:self
                action:@selector(moreClick:)
      forControlEvents:UIControlEventTouchUpInside];
    [topShaw addSubview:moreBtn];
    _popView = [[PopView alloc] initWithFrame:CGRectMake(ScreenWidth - 85, 57, 80, 50)];
    _popView.delegate = self;
    _popView.alpha = 0.0;
    _popView.hidden = YES;
    [self.view addSubview:_popView];
    
    /**
     *  底部控制
     */
    CGFloat bottomY = ScreenHeight / 3 + _playW / 2 + 50;
    bottomY = ScreenHeight - 210;
    CGFloat bottomH = ScreenHeight - bottomY;
    NSLog(@"%f", bottomH);
    CGRect bottomFrame = CGRectMake(0, bottomY, ScreenWidth, bottomH);
    _bottomView = [[PlayBottomController alloc] initWithFrame:bottomFrame];
    _bottomView.delegate = self;
    __weak typeof(self) wSelf = self;
    _bottomView.sliderBlock = ^(float sliderValue) {
        [wSelf.bottomView.playBtn setSelected:YES];
        [wSelf.player seekToTime:sliderValue];
    };
    _bottomView.playBlock = ^{
        [wSelf playBtn];
    };
    
    [self.view addSubview:_bottomView];
    
    _bottomView.nextOrLastBlock = ^(LastOrNext state) {
        if (state == LastSounds) {
            [wSelf lastSounds];
        } else if (state == NextSounds) {
            [wSelf nextSounds];
        }
    };
}

- (void)nextSounds {
    self.index++;
    if (self.index > self.soundsArr.count - 1) {
        self.index = 0;
    }
    [self.player pause];
    newDatasModel *model = self.soundsArr[self.index];
    self.dataModel = model;
}

- (void)lastSounds {
    self.index --;
    if (self.index < 0) {
        self.index = self.soundsArr.count - 1;
    }
    [self.player pause];
    newDatasModel *model = self.soundsArr[self.index];
    self.dataModel = model;
}

- (void)backBtnClick:(UIButton *)btn {
    [self.lcNavigationController popViewController];
}

- (void)moreClick:(UIButton *)btn {
    BOOL isShow = self.popView.hidden;
    
    __weak typeof(self) weakSelf = self;
    if (isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.popView.hidden = NO;
            weakSelf.popView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.popView.alpha = 0.0;
            weakSelf.popView.hidden = YES;
        }];
    }
}

- (void)playBtn {
    PlayAnimatView *animat = [PlayAnimatView sharePlayAnimatView];
    if (self.player.state == STKAudioPlayerStatePaused) {
        [_bottomView.playBtn setSelected:NO];
        [self.player resume];
        CFTimeInterval stopTime = [self.imageView.layer timeOffset];
        self.imageView.layer.beginTime = 0;
        self.imageView.layer.timeOffset = 0;
        self.imageView.layer.speed = 1;
        CFTimeInterval tempTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - stopTime;
        self.imageView.layer.beginTime = tempTime;
        [self basicAnimation];
        [animat startAnimating];
    } else if (self.player.state == STKAudioPlayerStatePlaying) {
        [_bottomView.playBtn setSelected:YES];
        [self.player pause];
        CFTimeInterval stopTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.imageView.layer.timeOffset = stopTime;
        self.imageView.layer.speed = 0;
        [animat stopAnimating];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    PlayAnimatView *animat = [PlayAnimatView sharePlayAnimatView];
    [super viewWillAppear:animated];
    if (self.player.state == STKAudioPlayerStatePlaying) {
        [self.imageView.layer removeAllAnimations];
        self.basicAnimation = nil;
        [self basicAnimation];
        
        [animat startAnimating];
    }else if (self.player.state == STKAudioPlayerStatePaused) {
        self.basicAnimation = nil;
        CFTimeInterval stopTime = [self.imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.imageView.layer.timeOffset = stopTime;
        self.imageView.layer.speed = 0;
        [animat stopAnimating];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (CABasicAnimation *)basicAnimation {
    if (_basicAnimation == nil) {
        self.basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        self.basicAnimation.duration = 30;
        self.basicAnimation.fromValue = [NSNumber numberWithInt:0];
        self.basicAnimation.toValue = [NSNumber numberWithInt:M_PI*2];
        [self.basicAnimation setRepeatCount:NSIntegerMax];
        [self.basicAnimation setAutoreverses:NO];
        [self.basicAnimation setCumulative:YES];
        self.imageView.layer.speed = 1;
        [self.imageView.layer addAnimation:self.basicAnimation forKey:@"basicAnimation"];
    }
    return _basicAnimation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setDataModel:(newDatasModel *)dataModel {
    [[DBManager sharedManager] insertModel:dataModel recordType:LAST_TYPE];
    if (self.dataModel.source == dataModel.source) {
        return;
    }
    _dataModel = dataModel;
    _soundsName.text = _dataModel.name;
    NSURL *downURL = [NSURL URLWithString:self.dataModel.pic_1080];
    [self createBgImageView:downURL];
    [self playMusic];
}

- (void)playMusic {
    
    if (self.player.state == STKAudioPlayerStatePlaying) {
        [self.imageView.layer removeAllAnimations];
        self.basicAnimation = nil;
        [self basicAnimation];
    }else if (self.player.state == STKAudioPlayerStatePaused) {
        self.basicAnimation = nil;
    }
    [self.imageView.layer removeAllAnimations];
    _basicAnimation = nil;
    [self basicAnimation];
    [self.player pause];
    PlayAnimatView *pav = [PlayAnimatView sharePlayAnimatView];
    [pav startAnimating];
    if (_dataModel.source) {
        [self dowloadSoundsWithUrl:_dataModel.source];
        _downLoad.isTest = YES;
        [_downLoad start];
        if (_downLoad.fileIsCreated) {
            NSURL *url = [NSURL fileURLWithPath:_downLoad.destinationPath];
            [XWBaseMethod showSuccessWithStr:@"播放本地音乐" toView:self.view];
            [self.player playURL:url];
        } else {
            [XWBaseMethod showSuccessWithStr:@"播放网络音乐" toView:self.view];
            [self.player play:_dataModel.source];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
        [self configNowPlayingInfoCenter];
    }
    
}

- (void)timeChange {
    
    _bottomView.progressSlider.maximumValue = self.player.duration;
    _bottomView.progressSlider.value = self.player.progress;
    
    NSInteger proMin = (NSInteger)self.player.progress / 60;
    NSInteger proSec = (NSInteger)self.player.progress % 60;
    
    self.durMin = (NSInteger)self.player.duration / 60;
    self.durSec = (NSInteger)self.player.duration % 60;
    
    _bottomView.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld", proMin, proSec];
    _bottomView.totalTime.text = [NSString stringWithFormat:@"%.2ld:%.2ld", self.durMin, self.durSec];
    if (self.durMin == proMin && self.durSec == proSec && self.player.progress > 0.5) {
        if (!_isSingle) {
            [self nextSounds];
        } else {
//            self.index --;
            [self playMusic];
        }
    }
}

- (void)setSoundsModel:(SoundsDatasModel *)soundsModel {
    _soundsModel = soundsModel;
    NSURL *downURL = [NSURL URLWithString:self.soundsModel.pic_1080];
    [self createBgImageView:downURL];
}

- (void)createBgImageView:(NSURL *)url {

    [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                    options:0
                                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (error) {
            NSLog(@"%@", error.description);
        } else {
            _bgImageView.image = image;
            _imageView.image = image;
        }
    }];
    BOOL isExist = [[DBManager sharedManager] isExistAppForAppId:_dataModel.id recordType:COLLEC_TYPE];
    [_bottomView.bottomCustom refreshBtnState:isExist];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    _isSingle = [ud boolForKey:SING_MARK];
    [_bottomView.bottomCustom refreshSingState:_isSingle];
    
    [self dowloadSoundsWithUrl:_dataModel.source];
    _downLoad.isTest = YES;
    [_downLoad start];
    [_bottomView.bottomCustom refreshDownState:_downLoad.fileIsCreated];
}

#pragma mark - STKAudioPlayerDelegate代理方法

-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId {
    NSLog(@"%s", __func__);
    [_bottomView.playBtn setSelected:NO];
}

-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*) queueItemId {
    NSLog(@"%s", __func__);
}

-(void)audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState {
    NSLog(@"%s -- %u", __func__, state);
    if (state == STKAudioPlayerStatePaused) {
        [_bottomView.playBtn setSelected:YES];
    }else if (state == STKAudioPlayerStatePlaying) {
        [_bottomView.playBtn setSelected:NO];
    }
}

-(void)audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration {
    NSLog(@"%s", __func__);
}

-(void)audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode {
    NSLog(@"%s%u", __func__, errorCode);
}

#pragma mark -BottomProtocol代理方法

- (void)bottomBtnProtocol:(ClickBtnType)type bottomView:(BottomCustomView *)playBottomView {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    switch (type) {
        case LoveBtnClick: {
            BOOL isExist = [[DBManager sharedManager] isExistAppForAppId:_dataModel.id recordType:COLLEC_TYPE];
            if (isExist) {
                [[DBManager sharedManager] deleteModelForAppId:_dataModel.id recordType:COLLEC_TYPE];
                [XWBaseMethod showSuccessWithStr:@"取消喜欢" toView:self.view];
            } else {
                [[DBManager sharedManager] insertModel:_dataModel recordType:COLLEC_TYPE];
                [XWBaseMethod showSuccessWithStr:@"喜欢" toView:self.view];
            }
            [playBottomView refreshBtnState:!isExist];
        }
            break;
        case DownBtnClick: {
            [self dowloadSoundsWithUrl:_dataModel.source];
            _downLoad.isTest = YES;
            [_downLoad start];
            if (_downLoad.fileIsCreated) {
                [XWBaseMethod showErrorWithStr:@"歌曲已下载" toView:self.view];
            } else {
                _downLoad.isTest = NO;
                [_downLoad start];
            }
        }
            break;
        case ShareBtnClick: {
            [self showShareView];
        }
            break;
        case SingBtnClick: {
            NSString *tmp = SING_MARK;
            _isSingle = [ud boolForKey:tmp];
            [ud setBool:!_isSingle forKey:tmp];
            NSString *showSing = !_isSingle ? @"单曲循环" : @"列表循环";
            [XWBaseMethod showSuccessWithStr:showSing toView:self.view];
            [playBottomView refreshSingState:!_isSingle];
        }
            break;
        case CommenBtnClick: {
            [self showCommentsView];
        }
            break;
        default:
            break;
    }
}

- (void)configNowPlayingInfoCenter {

//    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:_dataModel.name forKey:MPMediaItemPropertyTitle];
//        [dict setObject:_dataModel.channel forKey:MPMediaItemPropertyArtist];
//        if (self.bgImageView.image) {
//            UIImage *image = self.bgImageView.image;
//            MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
//            [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
//        }
//        [dict setObject:[NSNumber numberWithDouble:self.player.duration] forKey:MPMediaItemPropertyPlaybackDuration];
//        [dict setObject:[NSNumber numberWithDouble:self.player.progress] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
//    }
}

- (void)dowloadSoundsWithUrl:(NSString *)urlStr {
    
    _downLoad = [[MXLDownLoad alloc] initWithURL:urlStr startBlock:^(MXLDownLoad *downLoad) {

        [_bottomView.bottomCustom.downBtn setHidden:YES];
        [_bottomView.bottomCustom.downingView setHidden:NO];
        [_bottomView.bottomCustom.downingView startAnimating];
    } loadingBlock:^(MXLDownLoad *downLoad, double progressValue) {

    } finishBlock:^(MXLDownLoad *downLoad, NSString *filePath) {
 
        [_bottomView.bottomCustom.downBtn setHidden:NO];
        [_bottomView.bottomCustom.downingView setHidden:YES];
        [_bottomView.bottomCustom.downingView stopAnimating];
        [_bottomView.bottomCustom refreshDownState:YES];
        [self showAttentionAlert];
    } faildBlock:^(MXLDownLoad *downLoad, NSError *faildError) {
        
    } overFile:NO];
}

- (void)showAttentionAlert {
    
    [[DBManager sharedManager] insertModel:_dataModel recordType:DOWN_TYPE];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"下载完成" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:^{
    }];
}

- (void)showCommentsView {

    CommentsView *view = [CommentsView new];
    view.soundsID = _dataModel.id;
    view.bgImage = _bgImageView.image;
    view.view.frame = CGRectMake(0, 20, self.view.width, self.view.height - 20);
//    self.lcNavigationController.pageType = PageTypeNorMal;
    self.lcNavigationController.isComment = YES;
    [self.lcNavigationController pushViewController:view];
}

#pragma mark - SettingProtocol

- (void)turnToSettingPage:(NSInteger)btnTag {
    self.popView.hidden = YES;
    if (btnTag == 2) {
        PersonalViewController *pvc = nil;
        if (pvc == nil)
        pvc = [[PersonalViewController alloc] init];
        self.lcNavigationController.isComment = YES;
        [self.lcNavigationController pushViewController:pvc];
    } else if (btnTag == 1) {
        [XWBaseMethod showSuccessWithStr:@"举报成功"
                                  toView:self.view];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _popView.hidden = YES;
}

- (void)showShareView {
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56945b7467e58efff4000bb3"
                                      shareText:[NSString stringWithFormat:@"%@来这里试听%@", _dataModel.name, _dataModel.source]
                                     shareImage:[UIImage imageNamed:@"icon.png"]
                                shareToSnsNames:@[UMShareToSina]
                                       delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

@end
