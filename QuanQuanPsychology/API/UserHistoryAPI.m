//
//  UserHistoryAPI.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/8.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserHistoryAPI.h"

@implementation UserHistoryAPI

/* 观看历史 */
+(void)fetchUserHistoryWithUID:(NSString *)uid
                      callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    
    [self requestWithMethodName:@"getVideoRecord" body:body callback:callback];
}

@end
