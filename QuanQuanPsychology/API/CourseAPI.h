//
//  CourseAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface CourseAPI : BasicAPI

/* 考试科目选择器 */
+(void)fetchCourseNameWithCallback:(APIReturnBlock)callback;

/* 保存考试科目 地区 */
+(void)sendCourseID:(NSString *)courseID
                uid:(NSString *)uid
           callback:(APIReturnBlock)callback;

@end
