//
//  PlayVideoModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/17.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "PlayVideoModel.h"

@implementation PlayVideoModel

-(void)setModelWithDict:(NSDictionary *)dict{
    
    self.videoCoverPicPath = dict[@"coverUrl"];

    self.videoID = [NSString stringWithFormat:@"%@",dict[@"videoId"]];

    NSString *videoType = [NSString stringWithFormat:@"%@",dict[@"videoType"]];
    
    self.liveStatus = [videoType integerValue];
    
    self.videoURLs = dict[@"videoUrl"];
    
//    NSString *baseUrlStr = dict[@"videoUrl"];
//
//    NSData *data = [[NSData alloc] initWithBase64EncodedString:baseUrlStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
//
//    NSString *urlStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//
//    self.videoURL = [NSURL URLWithString:urlStr];
    
    
    NSString *vip = dict[@"isVip"];
    self.isVIP = [vip boolValue];
    
    self.liveTrialTime = [dict[@"seconds"] integerValue];
    
    self.vid = dict[@"vid"];
    
}



@end
