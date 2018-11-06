//
//  CardPackageAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageAPI.h"

@implementation CardPackageAPI

+(void)fetchCPTotalListWithUID:(NSString *)uid
                      courseID:(NSString *)courseID
                          type:(NSString *)type//1 全部 2 我的
                      callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",type,@"type", nil];
    
    
    
    [self requestWithMethodName:@"getPackageList" body:body callback:callback];
}

/* 获取小卡包列表 */
+(void)fetchCardPackageWithUID:(NSString *)uid
                          cpID:(NSString *)cpID
                      callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",cpID,@"cp_id", nil];

    [self requestWithMethodName:@"getCardPackageList" body:body callback:callback];
    
}

/* 获取我的卡包详情 */
+(void)fetchCardPackageDetailWithUID:(NSString *)uid
                            courseID:(NSString *)courseID
                           packageID:(NSString *)packageID
                            callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",packageID,@"cp_id", nil];

    [self requestWithMethodName:@"getCardPackage" body:body callback:callback];
    
}

/* 发送用户卡包所做题目 */
+(void)sendCardPackageExerciseQuestionWithUID:(NSString *)uid
                                       cardID:(NSString *)cardID
                                     quesList:(NSArray *)quesList
                                     callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",cardID,@"card_id",quesList,@"myList", nil];

    [self requestWithMethodName:@"saveMyCardPackageQuestion" body:body callback:callback];
    
}


/* 卡包学习卡数统计 */
+(void)fetchCPTotalCardsWithUID:(NSString *)uid
                           cpID:(NSString *)cpID
                       callback:(APIReturnBlock)callback{
        
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",cpID,@"cp_id", nil];
    
    [self requestWithMethodName:@"getAlreadPackageCardsCount" body:body callback:callback];
    
}

@end
