//
//  SecurityAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/4.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "SecurityAPI.h"

@implementation SecurityAPI

/* 校验单点登录 */
+(void)checkSingleSignOnWithUID:(NSString *)uid
                 identification:(NSString *)identification
                       callback:(APIReturnBlock)callback{
        
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          identification,@"identif",
                          nil];
    
    [self requestWithMethodName:@"getidentification" body:body callback:callback];
}

@end
