//
//  AppVersionAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/15.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface AppVersionAPI : BasicAPI

/* 获取App版本信息 */
+(void)fetchAppVersionWithCallback:(APIReturnBlock)callback;

@end
