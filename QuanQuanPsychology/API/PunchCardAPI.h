//
//  PunchCardAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface PunchCardAPI : BasicAPI

/* 获取打卡信息 */
+(void)fetchPunchCardInfoWithUID:(NSString *)uid
                        courseID:(NSString *)courseID
                        callback:(APIReturnBlock)callback;

/* 保存打卡信息 */
+(void)savePunchCardInfoWithUID:(NSString *)uid
                       callback:(APIReturnBlock)callback;

@end
