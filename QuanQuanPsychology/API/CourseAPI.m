//
//  CourseAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CourseAPI.h"

@implementation CourseAPI

/* 考试科目选择器 */
+(void)fetchCourseNameWithCallback:(APIReturnBlock)callback{
    
    NSDictionary *body = @{};
    
    [self requestWithMethodName:@"getAllExam" body:body callback:callback];
    
}

/* 保存考试科目 */
+(void)sendCourseID:(NSString *)courseID
                uid:(NSString *)uid
           callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",courseID,@"exam_id", nil];

    
    [self requestWithMethodName:@"saveMyExam" body:body callback:callback];
    
}

@end
