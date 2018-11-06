//
//  CourseGeneralModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/31.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface CourseGeneralModel : BasicModel

@property (copy, nonatomic) NSString *courseGeneralName;

@property (strong, nonatomic) NSArray *detailCourse;

@end


@interface CourseGradeModel : BasicModel

@property (copy, nonatomic) NSString *courseID;

@property (copy, nonatomic) NSString *courseGrade;

@end
