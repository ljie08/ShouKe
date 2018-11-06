//
//  AppVersionAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/15.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "AppVersionAPI.h"

@implementation AppVersionAPI

+(void)fetchAppVersionWithCallback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"1",@"type",
                          @"0",@"pageNo",
                          @"100",@"pageSize",
                          nil];
    [self requestWithMethodName:@"getVersionUpdateList" body:body callback:callback];
}

@end
