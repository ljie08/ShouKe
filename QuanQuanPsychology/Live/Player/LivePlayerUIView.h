//
//  LivePlayerUIView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/26.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveAdvancePlayerViewDelegate.h"
#import "LivePlayerDefine.h"

@protocol LivePlayerUIViewDelegate<NSObject>

/* 封面图播放 */
-(void)onCoverStartClick:(UIButton *)button;

/* 播放器返回事件 */
-(void)onBackClick:(UIButton *)button;

/* 开始播放 */
-(void)onStartClick:(UIButton *)button;

/* 暂停播放 */
-(void)onPauseClick:(UIButton *)button;

/* 播放器正常播放完毕 */
-(void)onFinish;

/* 播放器停止播放 */
-(void)onStop:(NSTimeInterval)currentPlayTime;

/* 播放器快进快退 */
-(void)onSeekDone:(NSTimeInterval)seekDoneTime;

/* 播放器锁屏 */
-(void)lockScreen:(BOOL)isLockScreen;

/* 视频清晰度切换 */
-(void)onVideoQualityChanged:(NSInteger)quality;

/* 播放器全屏 */
-(void)fullScreen:(BOOL)isFullScreen;

/* 循环播放 */
-(void)onCirclePlay;

/* 视频变速 */
-(void)onSpeedChanged:(CGFloat)speed;

/* 视频节点，跳到指定时间 */
- (void)seekToNodeTime:(NSTimeInterval)time;

@end

@interface LivePlayerUIView : UIView

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (assign, nonatomic) CGFloat currentTime;

@property (assign, nonatomic) CGFloat totalTime;

@property (assign, nonatomic) CGFloat sliderValue;

@property (assign, nonatomic) CGFloat progressValue;

@property (copy, nonatomic) NSString *imageURL;

@property (assign, nonatomic) BOOL isPlaying;

@property (assign, nonatomic) BOOL fullScreen;

@property (assign, nonatomic) BOOL hideToolView;

@property (strong, nonatomic) NSArray *videoQuality;

@property (assign, nonatomic) LiveCourseStatus liveStatus;//直播课程状态

@property (weak, nonatomic) id<LivePlayerUIViewDelegate>delegate;

@property (assign, nonatomic) CGFloat lastPlayTime;//历史播放时间 用于观看历史继续播放

@property (nonatomic, strong) NSString *vTitle;/**< 标题 */
@property (nonatomic, strong) NSArray *nodeArr;/**< 视频节点数组 */

-(void)resetSubviewPosition;

-(void)removeCover;

-(void)videoStart;

-(void)resetPopView;

@end
