//
//  HomeAPI.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeAPI.h"

@implementation HomeAPI

+(void)fetchHomeRecommendCourseWithCourseID:(NSString *)courseID
                                   callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"getChoiceCourse" body:body callback:callback];
    
}

+(void)fetchBannerImagesWithUID:(NSString *)uid
                       callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          nil];
    
    [self requestWithMethodName:@"getSowingMap" body:body callback:callback];
    
}

+(void)fetchHomeRecommendCPWithUID:(NSString *)uid
                          courseID:(NSString *)courseID
                               callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id", nil];
    
    [self requestWithMethodName:@"getHomeCardPackage" body:body callback:callback];
    
}


/* 首页打卡数据 */
+ (void)fetchPunchCardWithUID:(NSString *)uid
                     callback:(APIReturnBlock)callback {
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [self requestWithMethodName:@"getSign" body:body callback:callback];
}

/* 首页打卡 */
+ (void)savePunchCardWithUID:(NSString *)uid
                    callback:(APIReturnBlock)callback {
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid", nil];
    [self requestWithMethodName:@"saveMySign" body:body callback:callback];
}

@end
