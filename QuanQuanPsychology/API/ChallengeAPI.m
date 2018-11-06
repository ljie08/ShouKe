//
//  ChallengeAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "ChallengeAPI.h"

@implementation ChallengeAPI

/* 用户当前挑战的级别*/
+(void)fetchUserChallengeLevelWithUID:(NSString *)uid
                             courseID:(NSString *)courseID
                             callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id",nil];

    [self requestWithMethodName:@"getChapter" body:body callback:callback];
    
}

/* 用户挑战通过 */
+(void)challengePassedWithUID:(NSString *)uid
                     courseID:(NSString *)courseID
                        level:(NSString *)level
                     accuracy:(NSString *)accuracy
                     callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          level,@"num",
                          courseID,@"exam_id",
                          accuracy,@"accuracy",
                          nil];

    [self requestWithMethodName:@"addChapter" body:body callback:callback];
}


/* 发送级别 获取对应的题干 选项 */
+(void)fetchChallengeQuesWithUID:(NSString *)uid
                        courseID:(NSString *)courseID
                           level:(NSString *)level
                        callback:(APIReturnBlock)callback{
        
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",level,@"num",courseID,@"exam_id", nil];

    [self requestWithMethodName:@"getChallengeQuestions" body:body callback:callback];
}

@end
