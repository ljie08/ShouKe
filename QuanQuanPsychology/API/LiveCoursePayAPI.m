//
//  LiveCoursePayAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/28.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LiveCoursePayAPI.h"

@implementation LiveCoursePayAPI

/* 直播课订单校验 */
+(void)orderCheckingliveCourseOrderID:(NSString *)liveCourseOrderID
                              receipt:(NSString *)receipt
                             callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          liveCourseOrderID,@"id",
                          receipt,@"data",
                          nil];
    
    [self requestDiscoveryWithMethodName:@"validate" body:body callback:callback];
}

@end
