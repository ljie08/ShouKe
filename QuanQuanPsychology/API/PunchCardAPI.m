//
//  PunchCardAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "PunchCardAPI.h"

@implementation PunchCardAPI

/* 获取打卡信息 */
+(void)fetchPunchCardInfoWithUID:(NSString *)uid
                        courseID:(NSString *)courseID
                        callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",nil];

    [self requestWithMethodName:@"getSign" body:body callback:callback];
    
}

/* 保存打卡信息 */
+(void)savePunchCardInfoWithUID:(NSString *)uid
                       callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",nil];

    [self requestWithMethodName:@"saveMySign" body:body callback:callback];
    
}

@end
