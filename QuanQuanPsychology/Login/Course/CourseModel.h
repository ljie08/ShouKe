//
//  CourseModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/26.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface CourseModel : BasicModel<NSCoding>

@property (copy, nonatomic) NSString *course;

@property (copy, nonatomic) NSString *courseID;

@property (copy, nonatomic) NSString *courseGrade;

@end
