//
//  CourseModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/26.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CourseModel.h"

@implementation CourseModel

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_courseID forKey:@"courseID"];
    [aCoder encodeObject:_course forKey:@"course"];
    [aCoder encodeObject:_courseGrade forKey:@"courseGrade"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        _courseID = [aDecoder decodeObjectForKey:@"courseID"];
        _course = [aDecoder decodeObjectForKey:@"course"];
        _courseGrade = [aDecoder decodeObjectForKey:@"courseGrade"];
        
    }
    
    return self;
}

@end
