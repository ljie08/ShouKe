//
//  SecurityAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/4.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface SecurityAPI : BasicAPI

/* 校验单点登录 */
+(void)checkSingleSignOnWithUID:(NSString *)uid
                 identification:(NSString *)identification
                       callback:(APIReturnBlock)callback;

@end
