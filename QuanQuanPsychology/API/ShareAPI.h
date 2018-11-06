//
//  ShareAPI.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface ShareAPI : BasicAPI

/* 分享获取积分 */
+(void)getShareIntegrationWithUID:(NSString *)uid
                type:(NSString *)type
           callback:(APIReturnBlock)callback;

@end
