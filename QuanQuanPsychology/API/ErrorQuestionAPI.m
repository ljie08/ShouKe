//
//  ErrorQuestionAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "ErrorQuestionAPI.h"

@implementation ErrorQuestionAPI

/* 我的错题 */
+(void)fetchMyWrongQuesModuleWithUID:(NSString *)uid
                            courseID:(NSString *)courseID
                            callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id", nil];

    [self requestWithMethodName:@"getErrorQuestions" body:body callback:callback];
    
}

/* 删除我的错题 */
+(void)deleteMyWrongQuesWithQuesID:(NSString *)quesID
                          callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:quesID,@"myquestion_id",nil];

    [self requestWithMethodName:@"delErrorQuestion" body:body callback:callback];
    
}

@end
