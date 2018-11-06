//
//  VideoCourseModel.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/20.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "VideoCourseModel.h"

@implementation VideoCourseModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        
        self.courseID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.courseName = dict[@"title"];
        self.courseTeacher = dict[@"lecturer_name"];
        self.coursePrice = dict[@"price"];
        self.courseOwners = dict[@"counts"];
        self.imagePath = dict[@"list_pic_path"];
    }
    
    return self;
}

@end
