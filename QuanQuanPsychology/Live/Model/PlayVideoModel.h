//
//  PlayVideoModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/17.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"
#import "LivePlayerDefine.h"

@interface PlayVideoModel : BasicModel

@property (copy, nonatomic) NSString *videoTitle;/* 视频标题 */

@property (copy, nonatomic) NSString *videoCoverPicPath;/* 视频封面 */

@property (copy, nonatomic) NSString *videoID;/* 视频ID（自己服务器）*/

@property (assign, nonatomic) LiveCourseStatus liveStatus;/* 视频状态 */

@property (strong, nonatomic) NSDictionary *videoURLs;/* 各清晰度视频播放地址 */

@property (strong, nonatomic) NSURL *videoURL;/* 视频播放地址 */

@property (assign, nonatomic) BOOL isVIP;/* 视频是否已购买 */

@property (assign, nonatomic) NSInteger liveTrialTime;/* 视频试看时长 */

@property (copy, nonatomic) NSString *vid;/* 视频ID（阿里云服务器）*/

@property (copy, nonatomic) NSString *accessKeyID;/* 视频点播临时KeyID */

@property (copy, nonatomic) NSString *accessKeySecret;/* 视频点播临时KeySecret */

@property (copy, nonatomic) NSString *securityToken;/* 视频点播临时securityToken */


@end
