//
//  CourseGeneralModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/31.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "CourseGeneralModel.h"

@implementation CourseGeneralModel

-(void)setModelWithDict:(NSDictionary *)dict{
    
    self.courseGeneralName = dict[EXAMNAME];
    
    NSString *grade = dict[GRADE];
    
//    NSArray *array = [self stringToDict:grade];
//
//    for (int i = 0; i<array.count; i++) {
//        NSDictionary *dict = array[i];
//    }
    self.detailCourse = [self stringToDict:grade];
}

-(NSArray *)stringToDict:(NSString *)string{
    
    NSMutableArray *dictArray = [NSMutableArray array];
    NSArray *dicts = [string componentsSeparatedByString:@","];
    for (NSString *dict in dicts) {
        NSArray *array = [dict componentsSeparatedByString:@":"];
        
        CourseGradeModel *model = [[CourseGradeModel alloc] init];
        model.courseID = [NSString stringWithFormat:@"%@",array[0]];
        model.courseGrade = array[1];
//        NSDictionary *newDict = @{array[0]:array[1]};
        [dictArray addObject:model];
    }
    return dictArray;
}

@end

@implementation CourseGradeModel


@end


