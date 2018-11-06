//
//  EventAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "EventAPI.h"

@implementation EventAPI

/* 活动信息 */
+(void)fetchEventDetailWithCourseID:(NSString *)courseID
                           callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:courseID,@"exam_id", nil];

    [self requestWithMethodName:@"getActivityListByExamId" body:body callback:callback];
}

/* 邀请活动分享是否成功 */
+(void)isShareSuccessWithUID:(NSString *)uid
                    courseID:(NSString *)courseID
                     eventID:(NSString *)eventID
                    callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",eventID,@"activity_id", nil];

    [self requestWithMethodName:@"getInviteId" body:body callback:callback];
}

/* 激活邀请状态 */
+(void)activeInvitationStatusWithUID:(NSString *)uid
                               phone:(NSString *)phone
                            courseID:(NSString *)courseID
                            callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",phone,@"uphone", nil];

    [self requestWithMethodName:@"saveInviteStatu" body:body callback:callback];
}

/* 查询弹窗 */
+(void)checkPopupwithCourseID:(NSString *)courseID
                    callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:courseID,@"exam_id", nil];
    
    [self requestWithMethodName:@"getPopupByExamId" body:body callback:callback];
}



@end
