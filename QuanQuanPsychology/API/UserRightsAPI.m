//
//  UserRightsAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "UserRightsAPI.h"

@implementation UserRightsAPI

/* 卡片权限 */
+(void)rightForReadCardByPhone:(NSString *)phone
                      courseID:(NSString *)courseID
                      callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          phone,@"uphone",
                         courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"isNeedPopUp" body:body callback:callback];
}


/* 激活码验证 */
+(void)verifyActivationCode:(NSString *)code
                      phone:(NSString *)phone
                      courseID:(NSString *)courseID
                      callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          code,@"code",
                          phone,@"uphone",
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"checkActivationCode" body:body callback:callback];
}

@end
