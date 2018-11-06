//
//  PlayVideoAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/18.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "PlayVideoAPI.h"

@implementation PlayVideoAPI

+(void)getPlayAuthWithcallback:(APIReturnBlock)callback{
        
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"wii",@"wii",
                          nil];
    
    [self requestDiscoveryWithMethodName:@"getSts" body:body callback:callback];
}

/* 保存播放记录 */
+ (void)saveVideoRecordWithUID:(NSString *)uid
                       videoId:(NSString *)videoId
                          time:(NSString *)time
                      callback:(APIReturnBlock)callback {
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", videoId,@"video_id", time, @"complete_time", nil];
    [self requestDiscoveryWithMethodName:@"saveVideoRecord" body:body callback:callback];
}

+ (void)getVideoNodeWithVideoID:(NSString *)videoID callBack:(APIReturnBlock)callback {
//    getVideoNode
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:videoID,@"video_id", nil];
    [self requestDiscoveryWithMethodName:@"getVideoNode" body:body callback:callback];
}

@end
