//
//  PlayVideoAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/18.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface PlayVideoAPI : BasicAPI

/* 获取播放权限 */
+(void)getPlayAuthWithcallback:(APIReturnBlock)callback;


/* 保存播放记录 */
+ (void)saveVideoRecordWithUID:(NSString *)uid
                       videoId:(NSString *)videoId
                          time:(NSString *)time
                      callback:(APIReturnBlock)callback;

/* 获取视频节点 */
+ (void)getVideoNodeWithVideoID:(NSString *)videoID
                       callBack:(APIReturnBlock)callback;

@end
