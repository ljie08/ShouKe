//
//  VideoCourseModel.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/20.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface VideoCourseModel : BasicModel

/* 课程ID */
@property (copy, nonatomic) NSString *courseID;

/* 背景图路径 */
@property (copy, nonatomic) NSString *imagePath;

/* 课程名称 */
@property (copy, nonatomic) NSString *courseName;

/* 课程教师 */
@property (copy, nonatomic) NSString *courseTeacher;

/* 课程价格 */
@property (copy, nonatomic) NSString *coursePrice;

/* 报名课程人数 */
@property (copy, nonatomic) NSString *courseOwners;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
