//
//  LiveAdvancePlayerView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LiveAdvancePlayerView.h"
#import "LivePlayerUIView.h"
#import "PlayVideoModel.h"

#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import "NoticeView.h"
#import "NetworkChangeHelper.h"

#import "LivePlayerFastView.h"//快进/快退view

@interface LiveAdvancePlayerView()<AliyunVodPlayerDelegate,LivePlayerUIViewDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) LivePlayerUIView *playerUIView;

@property (assign, nonatomic) BOOL progressCanUpdate;

@property (strong, nonatomic) NoticeView *notice;

@property (strong, nonatomic) NetworkChangeHelper *network;

@property (strong, nonatomic) UIView *playerView;


@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) PlayMethod playMethod;

@property (strong, nonatomic) NSURL *currentURL;

@property (assign, nonatomic) BOOL inactiveStop;

@property (assign, nonatomic) NetworkStatus currentNetwork;

@property (nonatomic, assign) NSInteger playTag;/**< 100续播 200重新播 300普通播放（初始状态的开始或暂停后的开始）  */

@property (nonatomic, strong) LivePlayerFastView *fastview;/**< <#注释#> */

@end

@implementation LiveAdvancePlayerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self creatUI];
        [self addNetworkObserver];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.playerUIView.bounds = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.playerUIView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CGFloat noticeX ;
    
    if (self.playerViewState == LiveAdvancePlayerViewStateFullscreen) {
        noticeX = CGRectGetWidth(self.bounds) / 4;
    } else {
        noticeX = CGRectGetHeight(self.bounds) / 4;
    }
    
    self.notice.frame = CGRectMake(0, noticeX, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2);
    
}

-(void)dealloc{
    self.network = nil;
}

#pragma mark - 滑动快进或快退

- (void)creatFastView {
    if (!self.fastview) {
        self.fastview = [[LivePlayerFastView alloc] initWithFrame:CGRectMake(0, 0, 130, 83)];
    }
    self.fastview.center = self.playerUIView.center;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.beginPoint = [[touches anyObject] locationInView:self.playerUIView];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)pan {
//    CGPoint locationPoint = [pan locationInView:self.playerUIView];//手指当前位置
    CGPoint velocityPoint = [pan velocityInView:self.playerUIView];//手指移动的速度，上和右为正，反之为负，|x|>|y|为水平，否则为竖直
    CGPoint translatPoint = [pan translationInView:self.playerUIView];//手指移动的位置，上和右为正，反之为负
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 20.f;//当前屏宽
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {//开始移动
            [self creatFastView];
            [self.playerUIView addSubview:self.fastview];//添加快进快退提示图
        }
            break;
        case UIGestureRecognizerStateChanged: {//正在移动
            if (velocityPoint.x > 0) {//右
                self.fastview.fastType = FastForward;
            } else if (velocityPoint.x < 0) {//左
                self.fastview.fastType = FastBack;
            }
            
            CGFloat x = translatPoint.x / width;
            
            if (self.playerUIView.sliderValue > 1) {
                self.playerUIView.sliderValue = 1;
            } else if (self.playerUIView.sliderValue < 0) {
                self.playerUIView.sliderValue = 0;
            } else {
                if (velocityPoint.x > 0) {
                    x = x < 0 ? -x : x;
                    self.playerUIView.sliderValue = x + self.playerUIView.sliderValue;
                } else {
                    x = x > 0 ? -x : x;
                    self.playerUIView.sliderValue = x + self.playerUIView.sliderValue;
                }
            }
            
            NSTimeInterval time = self.aliPlayer.duration * self.playerUIView.sliderValue;
            
            NSString *fastTime = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",time]];//快进的时间
            NSString *totalTime = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",self.aliPlayer.duration]];
            self.fastview.timeStr = [NSString stringWithFormat:@"%@ / %@", fastTime, totalTime];
        }
            break;
        case UIGestureRecognizerStateEnded: {//移动结束
            
            NSTimeInterval time = self.aliPlayer.duration * self.playerUIView.sliderValue;
            [self.aliPlayer seekToTime:time];//快进
            
            [self.fastview removeFromSuperview];//提示图移除
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UI
-(void)creatUI{
    
    self.progressCanUpdate = YES;
    
    self.playerUIView = [[LivePlayerUIView alloc] initWithFrame:self.frame];
    self.playerUIView.delegate = self;
    
    self.playerUIView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.playerUIView addGestureRecognizer:pan];
    
    [self addSubview:self.playerUIView];
    
    /***********播放器界面搭建**************/
    self.playerView = self.aliPlayer.playerView;
    [self.playerUIView.contentView addSubview:self.playerView];
    
    [self.playerUIView resetSubviewPosition];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerViewTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

-(void)playNext{
    
    if (self.aliPlayer.playerState == AliyunVodPlayerStatePlay || self.aliPlayer.playerState == AliyunVodPlayerStatePause || self.aliPlayer.playerState == AliyunVodPlayerStateFinish) {
        [self.aliPlayer stop];
        self.currentURL = nil;
        [self startToPlay];
    } else {
       [self.playerUIView resetSubviewPosition];
    }
}

-(void)playerViewTap:(UITapGestureRecognizer *)tap{
    self.playerUIView.hideToolView = !self.playerUIView.hideToolView;

    if (!self.playerUIView.hideToolView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playerUIView.hideToolView = YES;
        });
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]] || touch.view == [self.playerUIView viewWithTag:100] || [touch.view isKindOfClass:[UISlider class]])
    {
        return NO;
    }
    return YES;
}

-(void)addNetworkObserver{
    
    __weak LiveAdvancePlayerView *weakSelf = self;
    
    self.network = [[NetworkChangeHelper alloc] init];
    self.currentNetwork = self.network.currentNetwork;
    
    self.network.becameActiveHelper = ^{
        if (weakSelf.aliPlayer) {
            if (weakSelf.aliPlayer.playerState == AliyunVodPlayerStatePause) {
                [weakSelf.aliPlayer resume];
            }
        }
    };
    
    self.network.resignActiveHelper = ^{
        if (weakSelf.aliPlayer) {
            if (weakSelf.aliPlayer.playerState == AliyunVodPlayerStatePlay) {
                [weakSelf.aliPlayer pause];
            }
        }
    };
    
    self.network.networkChange = ^(NetworkStatus status) {
        
        switch (status) {
                
            case NotReachable:
            {
                if (weakSelf.aliPlayer){
                    if (weakSelf.aliPlayer.playerState == AliyunVodPlayerStatePlay) {
                        [weakSelf.aliPlayer pause];
                    }
                }
                
                if (weakSelf.currentNetwork != NotReachable) {
                    [weakSelf creatNoticeWithType:NoticeViewTypeTextButton notice:@"当前无网络" btnTitles:@[@"继续播放"] btnAction:ButtonRefresh];
                }
                
                
                
            }
                break;
                
            case ReachableViaWiFi:
            {
                if (weakSelf.aliPlayer){
                    if (weakSelf.aliPlayer.playerState == AliyunVodPlayerStatePause) {
                        [weakSelf.aliPlayer resume];
                    }
                    
                    
                }
                
                if (weakSelf.currentNetwork != ReachableViaWiFi) {
                    [weakSelf creatNoticeWithType:NoticeViewTypeTextButton notice:@"当前为WiFi" btnTitles:@[@"继续播放"] btnAction:ButtonRefresh];
                }
                
                
            }
                break;
                
            case ReachableViaWWAN:
            {
                if (weakSelf.aliPlayer){
                    [weakSelf.aliPlayer pause];
                }
                
                if (weakSelf.currentNetwork != ReachableViaWWAN) {
                    [weakSelf creatNoticeWithType:NoticeViewTypeTextButton notice:@"是否使用移动网络播放" btnTitles:@[@"继续播放"] btnAction:ButtonRefresh];
                }
                
                
            }
                break;
                
            default:
                break;
        }
        
        weakSelf.currentNetwork = status;

    };
}

#pragma mark - Property
-(AliyunVodPlayer *)aliPlayer{
    if (!_aliPlayer) {
        _aliPlayer = [[AliyunVodPlayer alloc] init];
        _aliPlayer.delegate = self;
    }
    return _aliPlayer;
}

- (UIView *)playerView{
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        
    }
    return  _playerView;
}

-(void)setVideo:(PlayVideoModel *)video{
    
    _video = video;
    
    self.playerUIView.liveStatus = video.liveStatus;
    self.playerUIView.imageURL = video.videoCoverPicPath;
    self.playerUIView.vTitle = video.videoTitle;
    
    if ([NSString stringIsNull:video.vid]) {
        self.playMethod = PlayURL;
    } else {
        self.playMethod = PlaySTS;
    }
    
    self.inactiveStop = YES;
}

-(void)setRenewAuth:(BOOL)renewAuth{
    _renewAuth = renewAuth;
    if (renewAuth) {
        [self playTheVideo];
    }
}

-(void)setPlayerViewState:(LiveAdvancePlayerViewState)playerViewState{
    _playerViewState = playerViewState;
    
    if (playerViewState == LiveAdvancePlayerViewStateFullscreen) {
        self.playerUIView.fullScreen = YES;
    } else {
        self.playerUIView.fullScreen = NO;
    }
}

- (void)setLastPlayTime:(NSTimeInterval)lastPlayTime {
    _lastPlayTime = lastPlayTime;
    
    self.playerUIView.lastPlayTime = self.lastPlayTime;
}

- (void)setNodeList:(NSArray *)nodeList {
    _nodeList = nodeList;
}

#pragma mark - <AliyunVodPlayerDelegate>
- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer onEventCallback:(AliyunVodPlayerEvent)event {
    
    switch (event) {
        case AliyunVodPlayerEventPrepareDone:
        {//播放准备完成时触发
            
            [self.timer invalidate];
            if (self.video.liveStatus == CourseLiving) {
                self.playerUIView.sliderValue = 0;
                self.playerUIView.totalTime = 0;
            } else {
                self.playerUIView.totalTime = self.aliPlayer.duration;
                self.playerUIView.sliderValue = self.aliPlayer.currentTime/self.aliPlayer.duration;
                
            }
            self.playerUIView.nodeArr = self.nodeList;
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            
            [self creatQuanlityPopUp];

            self.inactiveStop = NO;

            [self.aliPlayer start];
            
            self.notice.success = YES;
            [self.notice dismissViewAfterDelay:0.5];
            self.playerUIView.isPlaying = YES;
            
        }
            break;
         
        case AliyunVodPlayerEventPlay:
        {//暂停后恢复播放时触发
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playerUIView.hideToolView = YES;
            });
        }
            break;
            
        case AliyunVodPlayerEventFirstFrame:
        {
            
        }
            break;
            
        case AliyunVodPlayerEventPause:
        {
            self.playerUIView.hideToolView = NO;
        }
            break;
            
        case AliyunVodPlayerEventStop:
        {
            if (!self.inactiveStop) {
                [self creatNoticeWithType:NoticeViewTypeTextButton notice:@"播放停止，是否重新加载" btnTitles:@[@"重试"] btnAction:ButtonRefresh];
            }
        }
            break;
            
        case AliyunVodPlayerEventFinish:
        {
            [self.timer invalidate];
            [self creatNoticeWithType:NoticeViewTypeTextButton notice:@"视频播放完毕，点击重播" btnTitles:@[@"重播"] btnAction:ButtonRestart];
            self.playerUIView.isPlaying = NO;
            
            if ([self.delegate respondsToSelector:@selector(onFinishWithLiveAdvancePlayerView:)]) {
                [self.delegate onFinishWithLiveAdvancePlayerView:self];
            }

        }
            break;
            
        case AliyunVodPlayerEventBeginLoading:
        {
            [self creatNoticeWithType:NoticeViewTypeIndicatorText notice:@"正在加载..." btnTitles:nil btnAction:0];
        }
            break;
            
        case AliyunVodPlayerEventEndLoading:
        {//加载完成
            if (self.lastPlayTime) {
                if (self.playTag == 100) {
                    self.playerUIView.sliderValue = self.lastPlayTime / self.aliPlayer.duration;
                    [self.aliPlayer seekToTime:self.lastPlayTime];
                } else if(self.playTag == 200) {
                    
                } else {
                    
                }
            }
            [self.notice dismissViewAfterDelay:0];
        }
            break;
            
        case AliyunVodPlayerEventSeekDone:
        {//进度
            self.progressCanUpdate = YES;
        }
            break;
        
    }
    
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer playBackErrorModel:(AliyunPlayerVideoErrorModel *)errorModel {
    
    if (errorModel) {
        
        if (errorModel.errorCode == 4002 ) {
            if ([self.delegate respondsToSelector:@selector(renewPlayAuth)]) {
                [self.delegate renewPlayAuth];
            }
        } else if (errorModel.errorCode == 4502){
            [self.notice dismissViewAfterDelay:0];
            [self creatNoticeWithType:NoticeViewTypeTextButton notice:@"视频正在转码中" btnTitles:@[@"知道了"] btnAction:ButtonRefresh];
        } else {
            NSString *errMsg = errorModel.errorMsg;
            [self.notice dismissViewAfterDelay:0];
            
            if ([errMsg containsString:@"格式不支持"]) {
                errMsg = @"网络信号不佳，建议更换网络";
            }
            
            [self creatNoticeWithType:NoticeViewTypeTextButton notice:errMsg btnTitles:@[@"重新加载"] btnAction:ButtonRefresh];
        }
    }
    
}

- (void)vodPlayer:(AliyunVodPlayer *)vodPlayer didSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
}

- (void)vodPlayer:(AliyunVodPlayer*)vodPlayer failSwitchToQuality:(AliyunVodPlayerVideoQuality)quality videoDefinition:(NSString*)videoDefinition{
    self.inactiveStop = NO;
}

#pragma mark - timerRun
- (void)timerRun:(NSTimer *)sender{
 
    //缓存文件大小， 路径要与开始设置相同。需要测试时打开
    //    [self fileSize];
    
    if (self.aliPlayer && self.progressCanUpdate ) {
        
        self.playerUIView.currentTime = self.aliPlayer.currentTime;
//        NSLog(@"\n😆currenttime - %f \n😀currentplay - %f - \n😀lasetime - %f", self.aliPlayer.currentTime, self.aliPlayer.currentPlayTime, self.lastPlayTime);
        
        
        self.playerUIView.progressValue = self.aliPlayer.loadedTime/self.aliPlayer.duration;
        
        if ([self.delegate respondsToSelector:@selector(currentPlayTime:)]) {
            [self.delegate currentPlayTime:self.aliPlayer.currentTime];
        }
        
        if (!self.video.isVIP && self.aliPlayer.currentTime > self.video.liveTrialTime && self.aliPlayer.playerState != AliyunVodPlayerStateStop) {
            [self.aliPlayer stop];
            self.playerUIView.isPlaying = NO;
            if ([self.delegate respondsToSelector:@selector(creatNonVipAlertForLiving:)]) {
                [self.delegate creatNonVipAlertForLiving:NO];
            }
        }
    }
    
    
}

#pragma mark - Notice
-(void)creatNoticeWithType:(NoticeViewType)type notice:(NSString *)notice btnTitles:(NSArray *)title btnAction:(NoticeButtonAction)action {
    
    if (self.notice) {
        [self.notice dismissViewAfterDelay:0];
    }
    
    self.notice = [[NoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) / 4, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 2)];
    
    [self.notice setNoticeWithType:type notice:notice btnTitles:title btnAction:action];
    
    
    if (type == NoticeViewTypeTextButton) {
        
       __weak LiveAdvancePlayerView *weakSelf = self;
        
        self.notice.completionHandler = ^(UIButton *button, NoticeButtonAction action) {
                        
            if (action) {
                if (action == ButtonContinue) {
                    [weakSelf.aliPlayer resume];
                } else if (action == ButtonRestart) {
                    [weakSelf playTheVideo];
                } else if (action == ButtonRefresh) {
                    if (weakSelf.aliPlayer.playerState == AliyunVodPlayerStatePause) {
                        [weakSelf.aliPlayer resume];
                    } else {
                        [weakSelf playTheVideo];
                    }
                }
            }
        };
    }
    
    [self addSubview:self.notice];
}

#pragma mark - Play
-(void)startToPlay{
    
    [self.aliPlayer reset];
    [self.playerUIView resetPopView];
    
    if (self.video.isVIP) {
        
        [self playTheVideo];
        
    } else {
        
        switch (self.video.liveStatus) {
            case CourseLiving:
            {
                
                if ([self.delegate respondsToSelector:@selector(creatNonVipAlertForLiving:)]) {
                    [self.delegate creatNonVipAlertForLiving:YES];
                }
            }
                break;
                
            case CoursePlayBack:
            {
                [self playTheVideo];
                
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)playTheVideo{
    
    [self.playerUIView removeCover];

    switch (self.playMethod) {
        case PlayURL:
        {
            if (self.currentURL == nil) {
                
                NSString *baseUrlStr = [self.video.videoURLs valueForKey:@"flv_sd"];
                
                if (![NSString stringIsNull:baseUrlStr]) {
                    NSData *data = [[NSData alloc] initWithBase64EncodedString:baseUrlStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    
                    NSString *urlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    
                    NSURL *url = [NSURL URLWithString:urlString];
                    
                    self.currentURL = url;
                }
                
            }
           
            
            [self.aliPlayer prepareWithURL:self.currentURL];
            

        }
            break;
            
        case PlaySTS:
        {
            
            [self.aliPlayer prepareWithVid:self.video.vid
                               accessKeyId:self.video.accessKeyID
                           accessKeySecret:self.video.accessKeySecret
                             securityToken:self.video.securityToken];
            
            
        }
            
            break;
            
        default:
            break;
    }
}

-(void)creatQuanlityPopUp{
    
    NSMutableArray *quality = [[NSMutableArray alloc] init];

    
    switch (self.playMethod) {
        case PlayURL:
        {
            self.playerUIView.videoQuality = @[@"流畅",@"标清",@"高清",@"超清"];
            
        }
            break;
            
        case PlaySTS:
        {
            AliyunVodPlayerVideo *videoModel = [self.aliPlayer getAliyunMediaInfo];
            
            NSArray *type = videoModel.allSupportQualitys;
            
            for (NSNumber *number in type) {
                if ([number integerValue] == 0) {
                    [quality addObject:@"流畅"];
                } else if ([number integerValue] == 1){
                    [quality addObject:@"标清"];
                } else if ([number integerValue] == 2){
                    [quality addObject:@"高清"];
                } else if ([number integerValue] == 3){
                    [quality addObject:@"超清"];
                }
            }
            
            self.playerUIView.videoQuality = [quality copy];

        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - <LivePlayerUIViewDelegate>
/* 封面图播放 */
-(void)onCoverStartClick:(UIButton *)button{
    self.playTag = button.tag;
    [self startToPlay];
}

/* 播放器返回事件 */
-(void)onBackClick:(UIButton *)button{
    
    if (self.playerViewState != LiveAdvancePlayerViewStateFullscreen) {
        
        if (self.aliPlayer != nil) {
            [self.aliPlayer stop];
            [self.aliPlayer releasePlayer];
            [self.aliPlayer.playerView removeFromSuperview];
            self.aliPlayer = nil;
            
            [self.timer invalidate];
            self.timer = nil;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(onBackClickWithLiveAdvancePlayer:)]) {
        self.playerUIView.fullScreen = button.isSelected;
        [self.delegate onBackClickWithLiveAdvancePlayer:self];
    }
}

/* 开始播放 */
-(void)onStartClick:(UIButton *)button{
    if (self.aliPlayer && self.aliPlayer.playerState == AliyunVodPlayerStatePause) {
        [self.aliPlayer resume];
    } else {
        [self.aliPlayer start];
    }
}

/* 暂停播放 */
-(void)onPauseClick:(UIButton *)button{
    if (self.aliPlayer) {
        [self.aliPlayer pause];
    }
}

/* 播放器正常播放完毕 */
-(void)onFinish{
    
}

/* 播放器停止播放 */
-(void)onStop:(NSTimeInterval)currentPlayTime{
    
}

/* 播放器快进快退 */
-(void)onSeekDone:(NSTimeInterval)seekDoneTime{
    
    if (self.aliPlayer && (self.aliPlayer.playerState == AliyunVodPlayerStateLoading || self.aliPlayer.playerState == AliyunVodPlayerStatePause ||
                           self.aliPlayer.playerState == AliyunVodPlayerStatePlay)) {
        self.progressCanUpdate = NO;
        [self.aliPlayer seekToTime:seekDoneTime * self.aliPlayer.duration ];
    }
}

/* 播放器锁屏 */
-(void)lockScreen:(BOOL)isLockScreen{
    
}

/* 视频清晰度切换 */
-(void)onVideoQualityChanged:(NSInteger)quality{
    
    self.inactiveStop = YES;
    
    switch (self.playMethod) {
        case PlayURL:
            {
                [self.aliPlayer stop];
                
                NSString *baseUrlStr = @"";
                
                switch (quality) {
                    case 0:
                        baseUrlStr = [self.video.videoURLs valueForKey:@"flv_ld"];
                        break;
                        
                    case 1:
                        baseUrlStr = [self.video.videoURLs valueForKey:@"flv_sd"];
                        break;
                        
                    case 2:
                        baseUrlStr = [self.video.videoURLs valueForKey:@"flv_gd"];
                        break;
                        
                    case 3:
                        baseUrlStr = [self.video.videoURLs valueForKey:@"flv_ud"];
                        break;
                        
                    default:
                        break;
                }
                
                
                NSData *data = [[NSData alloc] initWithBase64EncodedString:baseUrlStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                NSString *urlString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                if ([NSString stringIsNull:urlString]) {
                    [self creatNoticeWithType:NoticeViewTypeText notice:@"暂无该清晰度" btnTitles:nil btnAction:ButtonRefresh];
                    [self.notice dismissViewAfterDelay:1];
                } else {
                    NSURL *url = [NSURL URLWithString:urlString];
            
                    self.currentURL = url;
                    [self.aliPlayer prepareWithURL:url];
                }
                

            }
            break;
            
        case PlaySTS:
            {
                [self.aliPlayer setQuality:quality];
            }
            break;
            
        default:
            break;
    }
    
}

/* 播放器全屏 */
-(void)fullScreen:(BOOL)isFullScreen{
    if ([self.delegate respondsToSelector:@selector(liveAdvancePlayerView:fullScreen:)]) {
        [self.delegate liveAdvancePlayerView:self fullScreen:isFullScreen];
    }
    if (isFullScreen) {
    } else {
        self.fastview.frame = CGRectMake(0, 0, 130, 83);
    }
    self.fastview.center = self.playerUIView.center;
}

/* 循环播放 */
-(void)onCirclePlay{
    
}

/* 视频变速 */
-(void)onSpeedChanged:(CGFloat)speed{
    
    self.aliPlayer.playSpeed = speed;
}

/* 视频节点，跳到指定时间 */
- (void)seekToNodeTime:(NSTimeInterval)time {
//    self.playerUIView.sliderValue = time/self.aliPlayer.duration;
    [self.aliPlayer seekToTime:time];
}

#pragma mark - Tool
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}

@end
