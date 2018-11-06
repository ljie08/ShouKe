//
//  LiveAdvancePlayerView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveAdvancePlayerViewDelegate.h"
#import "LivePlayerDefine.h"

@class PlayVideoModel;

@interface LiveAdvancePlayerView : UIView

@property (weak, nonatomic) id<LiveAdvancePlayerViewDelegate>delegate;

@property (strong, nonatomic) PlayVideoModel *video;

@property (assign, nonatomic) BOOL renewAuth;

@property (strong, nonatomic) AliyunVodPlayer *aliPlayer;

@property (nonatomic, assign) NSTimeInterval lastPlayTime;/**< 上次播放的时间，观看记录 */
@property (nonatomic, strong) NSArray *nodeList;/**< 视频节点数组 */

#pragma mark - 全屏小屏切换
/* 记录小屏时的parentView */
@property (nonatomic, weak) UIView *liveAdvancePlayerViewParentView;

/* 记录小屏时的frame */
@property (nonatomic, assign) CGRect playerViewFrame;

@property (nonatomic, assign) LiveAdvancePlayerViewState playerViewState;

-(void)playNext;

@end
