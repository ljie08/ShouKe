//
//  UserStudyInfoAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "UserStudyInfoAPI.h"

@implementation UserStudyInfoAPI

/* 获取任务、排名、进度 */
+(void)fetchScheduledTaskWithUID:(NSString *)uid
                        courseID:(NSString *)courseID
                        callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"getScheduledTask" body:body callback:callback];
    
}

/* 获取科目图、进度 */
+(void)fetchCourseInfoWithUID:(NSString *)uid
                     courseID:(NSString *)courseID
                     callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
        
    [self requestWithMethodName:@"getHomePage" body:body callback:callback];
}

/* 获取预估考分 */
+(void)fetchPredictScoreWithUID:(NSString *)uid
                       courseID:(NSString *)courseID
                       callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
    
    
    [self requestWithMethodName:@"getPersonalComprehensiveScore" body:body callback:callback];
    
}

/* 获取通过率 */
+(void)fetchPassingRateWithUID:(NSString *)uid
                      courseID:(NSString *)courseID
                      callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"getTestPassingRate" body:body callback:callback];
    
}

/* 获取学习情况 */
+(void)fetchLearningSituationWithUID:(NSString *)uid
                            courseID:(NSString *)courseID
                            callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"getLearningSituation" body:body callback:callback];
    
}

/* 分享学习信息 */
+(void)shareStudyInfoWithUID:(NSString *)uid
                    courseID:(NSString *)courseID
                    callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"share" body:body callback:callback];
    
}

/* 获取卡包、书本、科目最大ID 用于内容上新提示 */
+(void)fetchUpdateContentWithCourseID:(NSString *)courseID
                             callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          courseID,@"exam_id",
                          nil];
    
    [self requestWithMethodName:@"getMaxIdByExamId" body:body callback:callback];
    
}

/* 发送用户学习所做题目 */
//0.pk 1.学习 2.练习 3.无限挑战
+(void)sendExerciseQuestionWithUID:(NSString *)uid
                          quesList:(NSArray *)quesList
                          callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          quesList,@"myList",
                          nil];
    
    [self requestWithMethodName:@"saveMyQuestion" body:body callback:callback];
    
}

@end
