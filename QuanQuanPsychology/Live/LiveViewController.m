//
//  LiveViewController.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/19.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LiveViewController.h"

#import "QuanIAPManager.h"
#import "CardPackageAPI.h"
#import "CardPackagePayAPI.h"
#import "PlayVideoAPI.h"

#import "KeyboardTextField.h"

#import "LivePlayerDefine.h"
#import "LiveAdvancePlayerView.h"
#import "VideoNodeModel.h"//视频节点
#import "ShareAPI.h"//分享得积分

@interface LiveViewController ()<IAPRequestResultsDelegate,LiveAdvancePlayerViewDelegate>

//IAP
@property (strong, nonatomic) NSString *liveCourseID;//直播课程ID
@property (strong, nonatomic) NSString *liveCourseOrderID;//直播课程订单ID

@property (strong, nonatomic) LiveAdvancePlayerView *advancePlayerView;


@property (strong, nonatomic) PlayVideoModel *video;

@property (assign, nonatomic) NSTimeInterval currentPlayTime;

@property (nonatomic, strong) NSMutableArray *nodeList;/**< <#注释#> */

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchPlayAuthForRenew:NO];
//    [self getVideoNode];
//    [self getShareScore];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self saveVideoRecord];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)dealloc{
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onPay"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onPlay"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onPlayMay"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"onChat"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"playRecord"];
    [self.webView clearWebCache];
    
}

-(PlayVideoModel *)video{
    if (!_video) {
        _video = [[PlayVideoModel alloc] init];
    }
    
    return _video;
}

- (PlayRecordModel *)record {
    if (!_record) {
        _record = [[PlayRecordModel alloc] init];
    }
    return _record;
}

- (NSMutableArray *)nodeList {
    if (!_nodeList) {
        _nodeList = [NSMutableArray array];
    }
    return _nodeList;
}

#pragma mark - data
- (void)saveVideoRecord {
    if (self.video.videoID && self.currentPlayTime) {
        [PlayVideoAPI saveVideoRecordWithUID:USERUID videoId:self.video.videoID time:[NSString stringWithFormat:@"%f", self.currentPlayTime] callback:^(APIReturnState state, id data, NSString *message) {
            if (state == API_SUCCESS) {
                
            } else {
                [self showHUDWithMode:MBProgressHUDModeText message:message];
                [self hideHUDAfter:1];
            }
        }];
    }
}

- (void)getVideoNode {
    [PlayVideoAPI getVideoNodeWithVideoID:self.video.videoID callBack:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSArray *list = [data objectForKey:@"list"];
            for (NSDictionary *dic in list) {
                VideoNodeModel *node = [[VideoNodeModel alloc] initWithDict:dic];
                [self.nodeList addObject:node];
            }
            self.advancePlayerView.nodeList = self.nodeList;
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

#pragma mark - Play Auth
-(void)fetchPlayAuthForRenew:(BOOL)renew{
    
    [PlayVideoAPI getPlayAuthWithcallback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            NSDictionary *dict = (NSDictionary *)data;
            self.video.accessKeyID = dict[@"AccessKeyId"];
            self.video.accessKeySecret = dict[@"AccessKeySecret"];
            self.video.securityToken = dict[@"SecurityToken"];
            
            if (renew) {
                self.advancePlayerView.renewAuth = renew;
            }
            
            
        } else {
            
        }
    }];
}

#pragma mark - UI
-(void)updateUI{
    
    [super updateUI];
        
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"onPay"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"onPlay"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"onPlayMay"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"onChat"];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"playRecord"];
    
    CGFloat width = ScreenWidth;
    CGFloat height = ScreenWidth * 9 / 16.0;
    
    self.advancePlayerView = [[LiveAdvancePlayerView alloc] initWithFrame:CGRectMake(0,0, width, height)];
    self.advancePlayerView.delegate = self;
    [self.view addSubview:self.advancePlayerView];
    
    self.webView.frame = CGRectMake(0, self.advancePlayerView.frame.size.height, ScreenWidth, ScreenHeight - self.advancePlayerView.frame.size.height);

}

-(void)creatKeyboardTextField{
    
    KeyboardTextField *tfView = [[KeyboardTextField alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
    
    tfView.textShouldSend = ^(BOOL send, NSString *content) {
        if (send) {
            
            NSString *chat = [NSString stringWithFormat:@"chat('%@')",content];
            
            [self.webView evaluateJavaScript:chat completionHandler:^(id _Nullable item, NSError * _Nullable error) {
                NSLog(@"send chat - %@",error.localizedDescription);
            }];
            
        } else {
            [self presentAlertWithTitle:@"请输入内容" message:@"" actionTitle:@"好的"];
        }
    };
    
    [self.navigationController.view addSubview:tfView];

    
    [UIView animateWithDuration:0.1 animations:^{
        tfView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}


#pragma mark - JS交互 - 发送观看时间
-(void)sendCurrentVideo:(NSString *)videoID withTime:(NSTimeInterval)time{
    
    if ([NSString stringIsNull:videoID]) {
        videoID = @"0";
    }
    
    NSString *stop = [NSString stringWithFormat:@"stopplay('%@','%f')",videoID,time];

    [self.webView evaluateJavaScript:stop completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"player stop - %@",error.localizedDescription);
    }];
}

/* 购买课程 */
-(void)purchase{
    
    NSString *define = [NSString stringWithFormat:@"define()"];
    
    [self.webView evaluateJavaScript:define completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"purchase error - %@",error.localizedDescription);
    }];
}

/* 视频正常播放结束 */
-(void)videoFinish{
    
    NSString *completion = [NSString stringWithFormat:@"completion('%@')",self.video.videoID];
    
    [self.webView evaluateJavaScript:completion completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"video completion error - %@",error.localizedDescription);
    }];
}

- (void)videoRecord {
    NSString *playRecord = [NSString stringWithFormat:@"playRecord('%@')", self.record.cousre_id];
    [self.webView evaluateJavaScript:playRecord completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"playRecord error - %@", error.localizedDescription);
    }];
}

#pragma mark - <WKScriptMessageHandler>
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    NSLog(@"body:%@,name:%@", message.body,message.name);

#pragma mark - 支付

    if ([message.name isEqualToString:@"onPay"]){
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dict = message.body;
            
            NSString *productID = dict[@"paystr"];
                        
            self.liveCourseID = dict[@"id"];
            
            self.liveCourseOrderID = dict[@"orderid"];
            
            if ([NSString stringIsNull:self.liveCourseOrderID]) {
                
                [self showHUDWithMode:MBProgressHUDModeText message:@"订单未生成，请稍后再试"];
                [self hideHUDAfter:1];

            } else {
                [self showHUDWithMode:MBProgressHUDModeIndeterminate message:@"正在处理"];
                

                [QuanIAPManager sharedInstance].delegate = self;
                [QuanIAPManager sharedInstance].livePay = YES;
                [[QuanIAPManager sharedInstance] requestProductWithId:productID andOrderID:self.liveCourseOrderID];
            }
            
        }
        
    }
    
#pragma mark - 播放
    else if ([message.name isEqualToString:@"onPlay"]){//old version
        
        /*
         videoType 无直播 0 直播中 1 回放, videoUrl 直播播放源 ；vid 点播播放源；coverUrl 图层url ； isVip 是否会员 0:否 1:是 ；seconds 试看时长 ;videoId 视频id
         onPlayMay(String videoType,String videoUrl,String vid,String coverUrl,String isVip,String seconds,String videoId)
         */
        
    }
    
    else if ([message.name isEqualToString:@"onPlayMay"]){//new version
        
        /*
         videoType 无直播 0 直播中 1 回放, videoUrl 直播播放源 ；vid 点播播放源；coverUrl 图层url ； isVip 是否会员 0:否 1:是 ；seconds 试看时长 ;videoId 视频id
         onPlayMay(String videoType,String videoUrl,String vid,String coverUrl,String isVip,String seconds,String videoId)
        */

        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            
            self.currentPlayTime = self.record.playtime ? self.record.playtime: self.currentPlayTime;
            
            NSString *videoid = [NSString stringWithFormat:@"%@", self.record.video_id ? self.record.video_id : self.video.videoID];
            [self sendCurrentVideo:videoid withTime:self.currentPlayTime];
            
            NSDictionary *dict = message.body;

            [self.video setModelWithDict:dict];
            
            self.advancePlayerView.lastPlayTime = self.currentPlayTime;
            self.advancePlayerView.video = self.video;
            
//            [self.advancePlayerView.aliPlayer seekToTime: self.advancePlayerView.aliPlayer.duration ];
            
            [self.advancePlayerView playNext];
            
//            [self getVideoNode];
        }
        
    }
    
    
#pragma mark - 直播分享

    else if ([message.name isEqualToString:@"onMenuShare"]){
        
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = message.body;

            [self initShareViewWithParams:dict];
        }
        
    }
    
#pragma mark - 聊天
    
    else if ([message.name isEqualToString:@"onChat"]){
        
        [self creatKeyboardTextField];
        
    }

}

//分享得积分
- (void)getShareScore {
    [ShareAPI getShareIntegrationWithUID:USERUID type:@"4" callback:^(APIReturnState state, id data, NSString *message) {
        if (state == API_SUCCESS) {
            
        } else {
            [self showHUDWithMode:MBProgressHUDModeText message:message];
            [self hideHUDAfter:1];
        }
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (self.record.video_id) {
        NSString *playRecord = [NSString stringWithFormat:@"playRecord('%@')", self.record.video_id];
        [self.webView evaluateJavaScript:playRecord completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            NSLog(@"playRecord error - %@", error.localizedDescription);
        }];
    }
}

#pragma mark - IAP
-(void)creatPurchaseAlertForLiving:(BOOL)living{
    
    NSString *title = @"试看结束请购买课程继续观看";
    
    if (living) {
        title = @"请先购买该课程";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self purchase];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {

    NSString *message = @"";

    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:
            NSLog(@"用户禁止应用内付费购买:%@",error);
            message = error;
            break;

        case IAP_FILEDCOED_NORIGHT:
            NSLog(@"用户禁止应用内付费购买");
            message = @"您的设备没有开启内置购买";
            break;

        case IAP_FILEDCOED_EMPTYGOODS:
            NSLog(@"商品为空");
            message = @"商品为空";
            break;

        case IAP_FILEDCOED_CANNOTGETINFORMATION:
            NSLog(@"无法获取产品信息，请重试");
            message = @"无法获取产品信息，请重试";
            break;

        case IAP_FILEDCOED_BUYFILED:
            NSLog(@"购买失败，请重试");
            message = @"购买失败，请重试";
            break;

        case IAP_FILEDCOED_USERCANCEL:
            NSLog(@"用户取消交易");
            message = @"您已取消交易";
            break;
            
        case IAP_FILEDCOED_LASTOREDERNOTFINISHED:
            NSLog(@"用户上次交易未完成");
            message = @"您上次的交易未完成";

        default:
            break;
    }

    [self updateHUDWithMode:MBProgressHUDModeText message:message];

    [self hideHUDAfter:1];

}

-(void)transactionSuccess{
    
    [self hideHUD];
    

    //payOrder(String uid,String id)
    

    NSString *payOrder = [NSString stringWithFormat:@"payOrder('%@','%@')",USERUID,self.liveCourseID];
    
    [self.webView evaluateJavaScript:payOrder completionHandler:^(id _Nullable item, NSError * _Nullable error) {
        NSLog(@"payOrder - %@",error.localizedDescription);
    }];
    
}

#pragma mark - <LiveAdvancePlayerViewDelegate>
-(void)onBackClickWithLiveAdvancePlayer:(LiveAdvancePlayerView *)playerView{
    
    if (playerView.playerViewState == LiveAdvancePlayerViewStateFullscreen) {
        [self exitFullscreen];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

/* 播放器正常播放完毕 */
-(void)onFinishWithLiveAdvancePlayerView:(LiveAdvancePlayerView *)playerView{
    
    if (playerView.playerViewState == LiveAdvancePlayerViewStateFullscreen) {
        [self exitFullscreen];
    }
    [self videoFinish];
}

-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView fullScreen:(BOOL)isFullScreen{
    if (isFullScreen) {
        [self enterFullscreen];
    } else {
        [self exitFullscreen];
    }
}

-(void)creatNonVipAlertForLiving:(BOOL)living{
    
    if (self.advancePlayerView.playerViewState == LiveAdvancePlayerViewStateFullscreen) {
        [self exitFullscreen];
    }
    [self creatPurchaseAlertForLiving:living];
}

-(void)currentPlayTime:(NSTimeInterval)time{
    self.currentPlayTime = time;
}

-(void)renewPlayAuth{
    [self fetchPlayAuthForRenew:YES];
}

#pragma mark - 全屏非全屏切换

- (void)enterFullscreen {
    
    if (self.advancePlayerView.playerViewState != LiveAdvancePlayerViewStateSmall) {
        return;
    }
    
    self.advancePlayerView.playerViewState = LiveAdvancePlayerViewStateAnimating;
    
    /*
     * 记录进入全屏前的parentView和frame
     */
    self.advancePlayerView.liveAdvancePlayerViewParentView = self.advancePlayerView.superview;
    self.advancePlayerView.playerViewFrame = self.advancePlayerView.frame;
    
    /*
     * movieView移到window上
     */
    CGRect rectInWindow = [self.advancePlayerView convertRect:self.advancePlayerView.bounds toView:[UIApplication sharedApplication].keyWindow];
    [self.advancePlayerView removeFromSuperview];
    self.advancePlayerView.frame = rectInWindow;
    [[UIApplication sharedApplication].keyWindow addSubview:self.advancePlayerView];
    
    /*
     * 执行动画
     */
    [UIView animateWithDuration:0.5 animations:^{
        self.advancePlayerView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.advancePlayerView.bounds = CGRectMake(0, 0, CGRectGetHeight(self.advancePlayerView.superview.bounds), CGRectGetWidth(self.advancePlayerView.superview.bounds));
        self.advancePlayerView.center = CGPointMake(CGRectGetMidX(self.advancePlayerView.superview.bounds), CGRectGetMidY(self.advancePlayerView.superview.bounds));
    } completion:^(BOOL finished) {
        self.advancePlayerView.playerViewState = LiveAdvancePlayerViewStateFullscreen;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)exitFullscreen {
    
    if (self.advancePlayerView.playerViewState != LiveAdvancePlayerViewStateFullscreen) {
        return;
    }
    
    self.advancePlayerView.playerViewState = LiveAdvancePlayerViewStateAnimating;
    
    CGRect frame = [self.advancePlayerView.liveAdvancePlayerViewParentView convertRect:self.advancePlayerView.playerViewFrame toView:[UIApplication sharedApplication].keyWindow];
    [UIView animateWithDuration:0.5 animations:^{
        self.advancePlayerView.transform = CGAffineTransformIdentity;
        self.advancePlayerView.frame = frame;
    } completion:^(BOOL finished) {
        /*
         * movieView回到小屏位置
         */
        [self.advancePlayerView removeFromSuperview];
        self.advancePlayerView.frame = self.advancePlayerView.playerViewFrame;
        [self.advancePlayerView.liveAdvancePlayerViewParentView addSubview:self.advancePlayerView];
        self.advancePlayerView.playerViewState = LiveAdvancePlayerViewStateSmall;
    }];
    
    [self refreshStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)refreshStatusBarOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}


@end
