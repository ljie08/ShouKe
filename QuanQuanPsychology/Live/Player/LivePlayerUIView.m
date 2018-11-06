//
//  LivePlayerUIView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/26.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LivePlayerUIView.h"
#import "LivePlayerPopupMenuView.h"
#import "LivePlayerSlider.h"
#import "LiveVideoNodeView.h"
#import "VideoNodeModel.h"

@interface LivePlayerUIView()<LivePlayerPopupMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIView *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIView *imageShadow;

@property (weak, nonatomic) IBOutlet UIView *bottomToolView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet LivePlayerSlider *playerSlider;

@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *speedBtn;

@property (weak, nonatomic) IBOutlet UIButton *qualityBtn;

@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalRPadding;//总时间距全屏按钮的距离

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;//底栏的高

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playW;//播放按钮宽

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playH;//播放按钮高

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullW;//全屏按钮宽

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullH;//全屏按钮高

@property (weak, nonatomic) IBOutlet UIView *topBg;//上边背景图
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题

@property (nonatomic, strong) LiveVideoNodeView *nodeView;/**< 视频节点view */

@end

@implementation LivePlayerUIView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self updateUI];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self updateUI];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)updateUI{
    
    [[NSBundle mainBundle] loadNibNamed:@"LivePlayerUIView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.frame;
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    UIImage *image = [[UIImage imageNamed:@"播放器进度条thumb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.playerSlider setThumbImage:image forState:UIControlStateNormal];
//    self.playerSlider.thumbTintColor = [UIColor colorwithHexString:@"#ff3636"];
    
    self.bottomToolView.hidden = YES;
    self.topBg.hidden = YES;
    
    [self resizeUIForScreen:NO];
    
}

- (void)addVideoNodeView {
    [self updateNodeView];
//    for (int i = 0; i < self.nodeArr.count; i++) {
//        VideoNodeModel *model = self.nodeArr[i];
//        CGFloat seconds = [model.time_node floatValue]/1000;
//
//        CGFloat x = self.playerSlider.frame.size.width * seconds/self.totalTime+CGRectGetMinX(self.playerSlider.frame)-1;//根据时间百分数计算节点的位置
//
//        //黄色节点
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, CGRectGetMidY(self.playerSlider.frame)-1, 4, 2)];
//        view.backgroundColor = [UIColor colorwithHexString:@"#ffde55"];
//        view.tag = 2000+i;
//
//        //可以点击的透明按钮
//        UIButton *nodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        nodeBtn.frame = CGRectMake(0, 0, 30, 30);
//        nodeBtn.center = view.center;
//        nodeBtn.backgroundColor = [UIColor clearColor];
//        nodeBtn.tag = 1000+i;
//        [nodeBtn addTarget:self action:@selector(showNodeView:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self.bottomToolView addSubview:view];
//        [self.bottomToolView addSubview:nodeBtn];
//    }
}

- (void)showNodeView:(UIButton *)button {
    if (!self.nodeView) {
        self.nodeView = [[LiveVideoNodeView alloc] init];//CGRectGetMinY(self.topBg.frame)
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seekToNode)];
//        [self.nodeView addGestureRecognizer:tap];
    }
    VideoNodeModel *model = self.nodeArr[button.tag-1000];
    CGSize size = [model.nodeDesc sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    CGFloat width = size.width+15+12+30+11;
    
    self.nodeView.frame = CGRectMake(CGRectGetMidX(button.frame)-width/2, CGRectGetMinY(self.bottomToolView.frame)-24, width, 37);
    self.nodeView.nodetitle = model.nodeDesc;
    [self addSubview:self.nodeView];
    
    weakSelf(self);
    CGFloat time = [model.time_node floatValue]/1000;
    self.nodeView.nodeBlock = ^{
        if ([weakSelf.delegate respondsToSelector:@selector(seekToNodeTime:)]) {
            [weakSelf.delegate seekToNodeTime:time];
        }
        weakSelf.playerSlider.value = time/weakSelf.totalTime;
    };
    
    for (UIView *view in self.bottomToolView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.nodeView removeFromSuperview];
            });
        }
    }
}

//- (void)pan:(UIPanGestureRecognizer *)panGesture {
//    if (_screenLocked) {
//        return;
//    }
//    if (!CGRectEqualToRect(_cannotTouchRect, CGRectZero)) {
//        return;
//    }
//    static NSTimeInterval playTimeAtPanStart = 0;
//    static BOOL canPan = NO;
//    CGPoint delta = [panGesture translationInView:_controlPanel];
//    CGPoint panPoint = [panGesture locationInView:_controlPanel];
//    
//    UIGestureRecognizerState state = panGesture.state;
//    if(state==UIGestureRecognizerStateBegan)
//    {
//        [_preparingPanel startRotateAnimation];
//        CGPoint point = [panGesture locationInView:_controlPanel];
//        CGPoint startPoint = CGPointMake(point.x-delta.x, point.y-delta.y);
//        _canPanMove = [self isPointHitControlPanelBar:startPoint];
//        canPan = NO;
//    }
//    if(state==UIGestureRecognizerStateChanged)
//    {
//        if (_canPanMove) return;
//        if (canPan == NO) {
//            if(delta.x*delta.x+delta.y*delta.y>miniMoveDis*miniGestureTime)//
//            {
//                
//                canPan = YES;
//                if(ABS(delta.x)>ABS(delta.y)) // 水平Pan
//                {
//                    _panMoveDirection = IJKPanMoveDirectionHorizontal;
//                    playTimeAtPanStart = _player.currentPlaybackTime;
//                }
//                else
//                    _panMoveDirection = IJKPanMoveDirectionVertical;
//                [panGesture setTranslation:CGPointZero inView:_controlPanel];
//                delta = CGPointZero;
//            }
//        }
//        
//        if (canPan) {
//            if(_panMoveDirection == IJKPanMoveDirectionVertical)//调节音量
//            {
//                //CGFloat *currentLight = [[UIScreen mainScreen] brightness];
//                NSLog(@"-------X-----,%ld",delta.x);
//                if (panPoint.x > PORTRAIT_MAIN_SCREEN_W/2) {
//                    [TKSystemVolume changeVolume:-delta.y*1.0/256];
//                }else {
//                    CGFloat currentLight = [[UIScreen mainScreen] brightness];
//                    currentLight += -delta.y*1.0/256;
//                    if (currentLight>1) {
//                        currentLight = 1;
//                    }
//                    [[UIScreen mainScreen] setBrightness:currentLight];
//                }
//                
//                //    [TKSystemVolume setVolume:-delta.y*1.0/256];
//                [panGesture setTranslation:CGPointZero inView:_controlPanel];
//            } else {
//                if (_isLvie) {
//                    return;
//                }
//                CGFloat x = ABS(delta.x);
//                if(x==0)
//                    _playTimeChangedByPan = 0;
//                else if(x<=_panSegmentLength)
//                    _playTimeChangedByPan = 10.0/_panSegmentLength*x;
//                else if(x<=_panSegmentLength*2)
//                    _playTimeChangedByPan = 10.0+20/_panSegmentLength*(x-_panSegmentLength);
//                else if(x<=_panSegmentLength*3)
//                    _playTimeChangedByPan = 10.0+20+50/_panSegmentLength*(x-_panSegmentLength*2);
//                else if(x<=_panSegmentLength*4)
//                    _playTimeChangedByPan = 10.0+20+50+100/_panSegmentLength*(x-_panSegmentLength*3);
//                else if(x<=_panSegmentLength*5)
//                    _playTimeChangedByPan = 10.0+20+50+100+200/_panSegmentLength*(x-_panSegmentLength*4);
//                else if(x<=_panSegmentLength*6)
//                    _playTimeChangedByPan = 10.0+20+50+100+200+400/_panSegmentLength*(x-_panSegmentLength*5);
//                else// if(x<=panSegmentLength*7)
//                    _playTimeChangedByPan = 10.0+20+50+100+200+400+600/_panSegmentLength*(x-_panSegmentLength*6);
//                if(delta.x<0)
//                    _playTimeChangedByPan = -_playTimeChangedByPan;
//                NSTimeInterval playTime = playTimeAtPanStart+_playTimeChangedByPan;
//                if(playTime<0)
//                    playTime = 0;
//                else if(playTime > _player.duration)
//                    playTime = _player.duration;
//                _seekTotimeL.text = [self timeStringFromDuration:playTime];
//                [self controlLoadingStatusWith:LoadingStatusSeeking bufferProgress:0];
//            } //end if 调节进度
//            
//            
//        }
//    }
//    
//    if(state==UIGestureRecognizerStateEnded)
//    {
//        
//        if(_panMoveDirection == IJKPanMoveDirectionHorizontal)//水平=调节播放进度
//        {
//            if (_isLvie) {
//                return;
//            }
//            
//            if (_networkLoseProtection&&(_sourceQuarlityType != ShowSourceQuarlityLocal)) {
//                if (_delegate&&[_delegate respondsToSelector:@selector(ijkPlayer:playerActionDidChanged:)]&&_networkLoseProtection) {
//                    [_delegate ijkPlayer:self playerActionDidChanged:IJKPlayerActionPlay];
//                }
//                _loadingPanel.hidden = YES;
//                return;
//            }
//            NSTimeInterval playTime = playTimeAtPanStart+_playTimeChangedByPan;
//            if(playTime<0)
//                playTime = 0;
//            else if(playTime > _player.duration)
//                playTime = _player.duration;
//            [self seekToTime:playTime];
//            //   _loadingPanel.hidden = YES;
//            [self controlLoadingStatusWith:LoadingStatusBuffering bufferProgress:0];
//        }
//    }
//}

//全屏切换时重新计算节点的位置
- (void)updateNodeView {
    CGFloat y = self.toolH.constant/2+0.5;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    for (int i = 0; i < self.nodeArr.count; i++) {
        UIView *view = [self viewWithTag:2000+i];
        UIButton *nodeBtn = [self viewWithTag:1000+i];
//        view.hidden = YES;
//        nodeBtn.hidden = YES;
        if (view) {
            [view removeFromSuperview];
        }
        if (nodeBtn) {
            [nodeBtn removeFromSuperview];
        }
        
        VideoNodeModel *model = self.nodeArr[i];
        CGFloat seconds = [model.time_node floatValue]/1000;
        CGFloat x = self.playerSlider.frame.size.width * seconds/self.totalTime+CGRectGetMinX(self.playerSlider.frame)-2;//根据时间百分数计算节点的位置
        if (self.fullScreen) {//全屏时节点位置不准确101和149是进度条距父视图左和右的距离
            x = (width-101-149) * (seconds/self.totalTime) +101 - 2;
        }
//        CGFloat v_x = (width-101-149) * (seconds/self.totalTime) +101 - 2;
        
        
        //黄色节点
//        view.frame = CGRectMake(x, CGRectGetMidY(self.playerSlider.frame)-1, 4, 2);
//
//        //可以点击的透明按钮
//        nodeBtn.frame = CGRectMake(0, 0, 30, 30);
//        nodeBtn.center = view.center;
//
//        view.hidden = NO;
//        nodeBtn.hidden = NO;
        
        //黄色节点
        view = [[UIView alloc] initWithFrame:CGRectMake(x, y-1, 4, 2)];
//        view = [[UIView alloc] initWithFrame:CGRectMake(v_x, y-1, 4, 2)];
        view.backgroundColor = [UIColor colorwithHexString:@"#ffde55"];
        view.tag = 2000+i;

        //可以点击的透明按钮
        nodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nodeBtn.frame = CGRectMake(0, 0, 30, 30);
        nodeBtn.center = view.center;
        nodeBtn.backgroundColor = [UIColor clearColor];
        nodeBtn.tag = 1000+i;
        [nodeBtn addTarget:self action:@selector(showNodeView:) forControlEvents:UIControlEventTouchUpInside];

        [self.bottomToolView addSubview:view];
        [self.bottomToolView addSubview:nodeBtn];
        
    }
}

-(void)resetSubviewPosition{
    [self.contentView bringSubviewToFront:self.bottomToolView];
    [self.contentView bringSubviewToFront:self.coverView];
    [self.contentView bringSubviewToFront:self.topBg];
    [self.contentView bringSubviewToFront:self.backBtn];
}

-(void)removeCover{
    [self.contentView sendSubviewToBack:self.coverView];
}

-(void)videoStart{
    self.bottomToolView.hidden = NO;
    self.playBtn.selected = YES;
}

-(void)resetPopView{
    [self.speedBtn setTitle:@"1.0X" forState:UIControlStateNormal];
    [self.qualityBtn setTitle:@"标清" forState:UIControlStateNormal];
}

-(void)resizeUIForScreen:(BOOL)fullScreen{
    //竖屏倍速按钮和标清按钮隐藏，全屏按钮显示
    self.speedBtn.hidden = YES;
    self.qualityBtn.hidden = YES;
    self.totalRPadding.constant = 10;
    self.fullScreenBtn.hidden = NO;
    if (fullScreen) {
        //全屏倍速按钮和标清按钮显示，全屏按钮隐藏
        self.toolH.constant = 54;
        self.playW.constant = 19;
        self.playH.constant = 24;
        self.fullW.constant = 25;
        self.fullH.constant = 22;
        self.qualityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.speedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.fullScreenBtn.hidden = YES;
        if (self.liveStatus == CoursePlayBack) {
            self.speedBtn.hidden = NO;
            self.qualityBtn.hidden = NO;
            self.totalRPadding.constant = 60;
        }
        
    } else {
        self.toolH.constant = 40;
        self.playW.constant = 11;
        self.playH.constant = 14;
        self.fullW.constant = 16;
        self.fullH.constant = 16;
        self.qualityBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        self.speedBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        
    }

//    [self updateNodeView];

}

#pragma mark - Property
- (void)setCurrentTime:(CGFloat)currentTime {
    
    _currentTime = currentTime;
    self.currentTimeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",currentTime]];
}
//-(void)setCurrentTime:(CGFloat)currentTime{
//}

-(void)setTotalTime:(CGFloat)totalTime{
    _totalTime = totalTime;
    self.totalTimeLabel.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%.f",totalTime]];
}

-(void)setSliderValue:(CGFloat)sliderValue{
    _sliderValue = sliderValue;
    [self.playerSlider setValue:sliderValue animated:YES];
}

-(void)setProgressValue:(CGFloat)progressValue{
    _progressValue = progressValue;
    [self.progressView setProgress:progressValue];
}

- (void)setVTitle:(NSString *)vTitle {
    _vTitle = vTitle;
    self.titleLab.text = vTitle;
}

-(void)setImageURL:(NSString *)imageURL{
    
    _imageURL = imageURL;
    
    imageURL = [imageURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:imageURL];
    
    [self.backgroundImage sd_setImageWithURL:url];
}

-(void)setLiveStatus:(LiveCourseStatus)liveStatus{
    
    _liveStatus = liveStatus;
    
    switch (liveStatus) {
            
        case CourseHasNotStart:
        {
            UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMidY(self.frame) - 23 , self.frame.size.width, 25)];
            tip.text = @"暂未开始";
            tip.textColor = [UIColor whiteColor];
            tip.textAlignment = NSTextAlignmentCenter;
            tip.font = [UIFont systemFontOfSize:18];
            [self.coverView addSubview:tip];
            
            UILabel *liveTime = [[UILabel alloc] initWithFrame:CGRectMake(0,tip.frame.size.height + tip.frame.origin.y + 2 , self.frame.size.width, 20)];
            liveTime.text = @"请关注直播时间";
            liveTime.textColor = [UIColor whiteColor];
            liveTime.textAlignment = NSTextAlignmentCenter;
            liveTime.font = [UIFont systemFontOfSize:14];
            [self.coverView addSubview:liveTime];

        }
            break;
            
        case CourseLiving:
        {
            UIButton *coverStart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 30, CGRectGetMidY(self.frame) - 30, 60, 60)];
            [coverStart setBackgroundImage:[UIImage imageNamed:@"视频播放"] forState:UIControlStateNormal];
            [coverStart setBackgroundImage:[UIImage imageNamed:@"视频暂停"] forState:UIControlStateSelected];
            [coverStart addTarget:self action:@selector(coverStartAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.coverView addSubview:coverStart];
            
            UILabel *liveTip = [[UILabel alloc] initWithFrame:CGRectMake(0,coverStart.frame.size.height + coverStart.frame.origin.y + 2 , self.frame.size.width, 25)];
            liveTip.text = @"正在直播…";
            liveTip.textColor = [UIColor whiteColor];
            liveTip.textAlignment = NSTextAlignmentCenter;
            liveTip.font = [UIFont systemFontOfSize:18];
            [self.coverView addSubview:liveTip];

        }
            break;
            
        case CoursePlayBack:
        {
            if (self.lastPlayTime) {
                UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-230)/2, (self.frame.size.height-80)/2, 230, 70)];
                bgview.backgroundColor = [UIColor clearColor];
                UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 30)];
                NSInteger playtime = round(self.lastPlayTime);
                timeL.font = [UIFont systemFontOfSize:14];
                timeL.text = [NSString stringWithFormat:@"上次播放到%ld分%ld秒", playtime/60, playtime%60];
                timeL.textColor = [UIColor whiteColor];
                timeL.backgroundColor = [UIColor clearColor];
                timeL.textAlignment = NSTextAlignmentCenter;
                [bgview addSubview:timeL];
                
                UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                continueBtn.frame = CGRectMake(0, 50, 100, 30);
                continueBtn.backgroundColor = [UIColor clearColor];
                [continueBtn setTitle:@"继续观看" forState:UIControlStateNormal];
                [continueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                continueBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                continueBtn.tag = 100;
                continueBtn.layer.borderWidth = 1;
                continueBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                continueBtn.layer.cornerRadius = 5;
                [continueBtn addTarget:self action:@selector(coverStartAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgview addSubview:continueBtn];
                
                UIButton *restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                restartBtn.frame = CGRectMake(130, 50, 100, 30);
                restartBtn.backgroundColor = [UIColor clearColor];
                [restartBtn setTitle:@"重新观看" forState:UIControlStateNormal];
                [restartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                restartBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                restartBtn.tag = 200;
                restartBtn.layer.borderWidth = 1;
                restartBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                restartBtn.layer.cornerRadius = 5;
                [restartBtn addTarget:self action:@selector(coverStartAction:) forControlEvents:UIControlEventTouchUpInside];
                [bgview addSubview:restartBtn];
                
                [self.coverView addSubview:bgview];
            } else {
                UIButton *coverStart = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 30, CGRectGetMidY(self.frame) - 30, 60, 60)];
                [coverStart setBackgroundImage:[UIImage imageNamed:@"视频播放"] forState:UIControlStateNormal];
                [coverStart setBackgroundImage:[UIImage imageNamed:@"视频暂停"] forState:UIControlStateSelected];
                coverStart.tag = 300;
                [coverStart addTarget:self action:@selector(coverStartAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.coverView addSubview:coverStart];
            }

        }
            break;
    }
}

-(void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    
    if (isPlaying) {
        self.bottomToolView.hidden = NO;
        self.playBtn.selected = YES;
    } else {
        self.playBtn.selected = NO;
    }
}

-(void)setHideToolView:(BOOL)hideToolView{
    _hideToolView = hideToolView;
    
    self.backBtn.hidden = hideToolView;
    self.bottomToolView.hidden = hideToolView;
    self.topBg.hidden = hideToolView;
    
    LivePlayerPopupMenuView *speedMenu = [self viewWithTag:101];
    LivePlayerPopupMenuView *qualityMenu = [self viewWithTag:102];

    if (speedMenu != nil ) {
        speedMenu.hidden = hideToolView;
    }
    
    if (qualityMenu != nil ) {
        qualityMenu.hidden = hideToolView;
    }
}

-(void)setFullScreen:(BOOL)fullScreen{
    _fullScreen = fullScreen;
    self.fullScreenBtn.selected = fullScreen;
    
    [self resizeUIForScreen:fullScreen];
}

- (void)setLastPlayTime:(CGFloat)lastPlayTime {
    _lastPlayTime = lastPlayTime;
    self.playerSlider.value = lastPlayTime / self.totalTime;
}

- (void)setNodeArr:(NSArray *)nodeArr {
    _nodeArr = nodeArr;
    
    [self addVideoNodeView];
}

#pragma mark - Button Actions
-(void)coverStartAction:(UIButton *)button{
    if (button.tag == 200) {
        self.sliderValue = 0.0f;
    }
    if ([self.delegate respondsToSelector:@selector(onCoverStartClick:)]) {
        [self.delegate onCoverStartClick:button];
    }
}

- (IBAction)back:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(onBackClick:)]) {
        
        [self.delegate onBackClick:sender];
    }
    
}

- (IBAction)play:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    if (sender.selected && [self.delegate respondsToSelector:@selector(onStartClick:)]) {
        [self.delegate onStartClick:sender];
    }
    
    if (!sender.selected && [self.delegate respondsToSelector:@selector(onPauseClick:)]) {
        [self.delegate onPauseClick:sender];
    }
}

- (IBAction)timeChange:(LivePlayerSlider *)sender {
    
    NSTimeInterval time = sender.value;
    
    if ([self.delegate respondsToSelector:@selector(onSeekDone:)]) {
        [self.delegate onSeekDone:time];
    }
}

/**
 播放速度

 @param sender <#sender description#>
 */
- (IBAction)speedChange:(UIButton *)sender {
    /*
    static NSInteger speedClick = 0;
    
    speedClick++;
    
    NSInteger rest = speedClick % 3;
    CGFloat speed;
    
    NSString *title;
    
    switch (rest) {
        case 0:
            title = @"1.0X";
            speed = 1.0;
            break;
            
        case 1:
            title = @"1.5X";
            speed = 1.5;
            break;
            
        case 2:
            title = @"2.0X";
            speed = 2.0;
            break;
            
        default:
            title = @"1.0X";
            speed = 1.0;
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(onSpeedChanged:)]) {
        [self.delegate onSpeedChanged:speed];
        [self.speedBtn setTitle:title forState:UIControlStateNormal];
    }
    */
    
    LivePlayerPopupMenuView *view = [self viewWithTag:101];
    if (view == nil) {
       
        CGFloat width = [UIScreen mainScreen].bounds.size.width;//236*Width_Scale;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat q_w = 236*height/375;
        
        LivePlayerPopupMenuView *qualityMenu = [[LivePlayerPopupMenuView alloc] initWithFrame:CGRectMake(width-q_w, 0, q_w, height)];
        [qualityMenu creatPopupWithTitles:@[@"1.0x", @"1.5x", @"2.0x"] screen:self.fullScreen];
        qualityMenu.delegate = self;
        
        qualityMenu.tag = 101;
        [self addSubview:qualityMenu];
    } else {
        [view removeFromSuperview];
    }
    /*
    LivePlayerPopupMenuView *view = [self viewWithTag:101];

    if (view == nil) {
        LivePlayerPopupMenuView *speedMenu = [[LivePlayerPopupMenuView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.speedBtn.frame),CGRectGetHeight(self.frame) -  CGRectGetHeight(self.speedBtn.frame) * 3 - CGRectGetHeight(self.bottomToolView.frame), CGRectGetWidth(self.speedBtn.frame), CGRectGetHeight(self.speedBtn.frame) * 3)];

        speedMenu.delegate = self;
        speedMenu.titles = @[@"1.0X",@"1.5X",@"2.0X"];
        speedMenu.tag = 101;
        [self addSubview:speedMenu];
    } else {
        [view removeFromSuperview];
    }
    */
    
}

/**
 清晰度改变

 @param sender <#sender description#>
 */
- (IBAction)qualityChange:(UIButton *)sender {
    
    LivePlayerPopupMenuView *view = [self viewWithTag:102];
    
    if (view == nil && self.videoQuality.count != 0) {
        
//        CGFloat height;
        
//        if (self.fullScreen) {
//            height = 40;
//        } else {
//            height = 26;
//        }
        
//        LivePlayerPopupMenuView *qualityMenu  = [[LivePlayerPopupMenuView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.qualityBtn.frame),CGRectGetHeight(self.frame) -  height * self.videoQuality.count - CGRectGetHeight(self.bottomToolView.frame), CGRectGetWidth(self.qualityBtn.frame), height * self.videoQuality.count)];
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;//236*Width_Scale;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat q_w = 236*height/375;
        
        LivePlayerPopupMenuView *qualityMenu = [[LivePlayerPopupMenuView alloc] initWithFrame:CGRectMake(width-q_w, 0, q_w, height)];
//        LivePlayerPopupMenuView *qualityMenu = [[LivePlayerPopupMenuView alloc] initWithFrame:CGRectMake(ScreenHeight-width, 0, width, ScreenWidth)];
        [qualityMenu creatPopupWithTitles:self.videoQuality screen:self.fullScreen];
        qualityMenu.delegate = self;
        
//        qualityMenu.titles = self.videoQuality;
//        qualityMenu.fullScreen = self.fullScreen;
        qualityMenu.tag = 102;
        [self addSubview:qualityMenu];
    } else {
        [view removeFromSuperview];
    }
    
}

/**
 全屏

 @param sender <#sender description#>
 */
- (IBAction)fullScreen:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    
    LivePlayerPopupMenuView *speedView = [self viewWithTag:101];
    LivePlayerPopupMenuView *qualityView = [self viewWithTag:102];
    
    
    if (speedView != nil) {
        [speedView removeFromSuperview];
    }
    
    if (qualityView != nil) {
        [qualityView removeFromSuperview];
    }
    
    if ([self.delegate respondsToSelector:@selector(fullScreen:)]) {
        [self.delegate fullScreen:sender.selected];
        self.fullScreen = sender.selected;
        [self resizeUIForScreen:sender.selected];
    }
//    [self updateNodeView];
}

#pragma mark - <LivePlayerPopupMenuViewDelegate>
-(void)popupMenu:(LivePlayerPopupMenuView *)menu onMenuClick:(UIButton *)button{
    
    if (menu.tag == 101) {
        
        /* 速度 */
        CGFloat speed;
        
        switch (button.tag) {
            case 0:
                speed = 1.0;
                break;
                
            case 1:
                speed = 1.5;
                break;
                
            case 2:
                speed = 2.0;
                break;
                
            default:
                speed = 1.0;
                break;
        }
        
        if ([self.delegate respondsToSelector:@selector(onSpeedChanged:)]) {
            [self.delegate onSpeedChanged:speed];
            [self.speedBtn setTitle:button.currentTitle forState:UIControlStateNormal];
            [menu removeFromSuperview];
        }
        
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(onVideoQualityChanged:)]) {
            [self.delegate onVideoQualityChanged:button.tag];
            [self.qualityBtn setTitle:button.currentTitle forState:UIControlStateNormal];
//            self.playBtn.selected = YES;
            [menu removeFromSuperview];
        }
        
    }
    
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
