//
//  ShareAPI.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

//分享得积分
#import "ShareAPI.h"

@implementation ShareAPI

/* 分享获取积分 */
+(void)getShareIntegrationWithUID:(NSString *)uid
                             type:(NSString *)type
                         callback:(APIReturnBlock)callback {
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",type,@"type", nil];
    
    [self requestWithMethodName:@"getShareIntegration" body:body callback:callback];
}

@end
