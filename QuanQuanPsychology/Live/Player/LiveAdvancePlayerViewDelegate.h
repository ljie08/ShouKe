//
//  LiveAdvancePlayerViewDelegate.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#ifndef LiveAdvancePlayerViewDelegate_h
#define LiveAdvancePlayerViewDelegate_h

@class LiveAdvancePlayerView;
#import <AliyunVodPlayerSDK/AliyunVodPlayerSDK.h>

@protocol LiveAdvancePlayerViewDelegate <NSObject>

@optional

/* 封面图播放 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onCoverStart:(UIButton *)button;

/* 播放器返回事件 */
-(void)onBackClickWithLiveAdvancePlayer:(LiveAdvancePlayerView *)playerView;

/* 开始播放 */
-(void)onStartClickWithLiveAdvancePlayer:(LiveAdvancePlayerView *)playerView;

/* 暂停播放 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onPause:(NSTimeInterval)currentPlayTime;

/* 暂停后恢复播放 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onResume:(NSTimeInterval)currentPlayTime;

/* 播放器正常播放完毕 */
-(void)onFinishWithLiveAdvancePlayerView:(LiveAdvancePlayerView *)playerView;

/* 播放器停止播放 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onStop:(NSTimeInterval)currentPlayTime;

/* 播放器快进快退 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onSeekDone:(NSTimeInterval)seekDoneTime;

/* 播放器锁屏 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView lockScreen:(BOOL)isLockScreen;

/* 视频清晰度切换 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onVideoQualityChanged:(AliyunVodPlayerVideoQuality)quality;

/* 播放器全屏 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView fullScreen:(BOOL)isFullScreen;

/* 循环播放 */
-(void)onCircleStartWithLiveAdvancePlayerView:(LiveAdvancePlayerView *)playerView;

/* 视频变速 */
-(void)liveAdvancePlayerView:(LiveAdvancePlayerView *)playerView onSpeedChanged:(CGFloat)speed;

/* 购买提示框 */
-(void)creatNonVipAlertForLiving:(BOOL)living;

/* 当前播放时长 */
-(void)currentPlayTime:(NSTimeInterval)time;

/* 重新获取播放权限 */
-(void)renewPlayAuth;

@end


#endif /* LiveAdvancePlayerViewDelegate_h */
