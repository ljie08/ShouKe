//
//  NewsNotificationAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "NewsNotificationAPI.h"

@implementation NewsNotificationAPI

/* 我的消息 */
+(void)fetchMyNewsWithUID:(NSString *)uid
                 callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",@"1",@"type",nil];

    
    [self requestWithMethodName:@"getMessageList" body:body callback:callback];
}

+(void)fetchUnreadMessageWithUID:(NSString *)uid readTime:(NSString *)time callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",@"1",@"type",time,@"readDate",nil];

    [self requestWithMethodName:@"getUnreadMessage" body:body callback:callback];
}

@end
