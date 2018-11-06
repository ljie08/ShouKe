//
//  CardPackageDetailModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/27.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageDetailModel.h"

#define CPBACKGROUNDPIC @"bg_pic"
#define CPEXAMTIME @"exam_time"
#define CPEXAMINEE @"examinee"
#define CPTYPE @"type"
#define CPAMOUNT @"amount"

@implementation CardPackageDetailModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        
        self.ownCardPackage = [dict[@"haveCardPackage"] boolValue];
        
        self.courseName = dict[EXAMNAME];
        self.courseLevel = dict[EXAMGRADE];
        
        self.cpID = [NSString stringWithFormat:@"%@",dict[CARDPACKAGEID]];
        self.cpTitle = dict[CARDPACKAGETITLE];
        self.cpBackgroundPic = dict[CPBACKGROUNDPIC];
        self.cpDescription = dict[@"cardPackageDetail"];
        
        self.targetPerson = dict[CPEXAMINEE];
        
        NSString *type =[NSString stringWithFormat:@"%@",dict[CPTYPE]];
        
        switch ([type integerValue]) {
            case 1:
                self.cpType = CP_Free;
                break;
                
            case 2:
                self.cpType = CP_Paid;
                break;
                
            case 3:
                self.cpType = CP_Share;
                break;
                
            default:
                self.cpType = CP_Free;
                break;
        }
        
        self.cpAmount = dict[CPAMOUNT];
        self.cpProductID = [NSString stringWithFormat:@"%@",dict[@"product_id"]];
        self.examQuesTime = dict[CPEXAMTIME];
        self.subjectName = dict[SUBJECTNAME];

    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:_ownCardPackage forKey:@"ownCardPackage"];
    [aCoder encodeObject:_cpID forKey:@"cpID"];
    [aCoder encodeObject:_cpTitle forKey:@"cpTitle"];
    [aCoder encodeObject:_cpBackgroundPic forKey:@"cpBackgroundPic"];
    [aCoder encodeObject:_cpDescription forKey:@"cpDescription"];
    [aCoder encodeObject:_courseName forKey:@"courseName"];
    [aCoder encodeObject:_courseLevel forKey:@"courseLevel"];
    [aCoder encodeObject:_examQuesTime forKey:@"examQuesTime"];
    [aCoder encodeObject:_subjectName forKey:@"subjectName"];
    [aCoder encodeObject:_targetPerson forKey:@"targetPerson"];
    [aCoder encodeInteger:_cpType forKey:@"cpType"];
    [aCoder encodeObject:_cpAmount forKey:@"cpAmount"];
    [aCoder encodeObject:_cpProductID forKey:@"cpProductID"];
    

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _ownCardPackage = [aDecoder decodeBoolForKey:@"ownCardPackage"];
        _cpID = [aDecoder decodeObjectForKey:@"cpID"];
        _cpTitle = [aDecoder decodeObjectForKey:@"cpTitle"];
        _cpBackgroundPic = [aDecoder decodeObjectForKey:@"cpBackgroundPic"];
        _cpDescription = [aDecoder decodeObjectForKey:@"cpDescription"];
        _courseName = [aDecoder decodeObjectForKey:@"courseName"];
        _courseLevel = [aDecoder decodeObjectForKey:@"courseLevel"];
        _examQuesTime = [aDecoder decodeObjectForKey:@"examQuesTime"];
        _subjectName = [aDecoder decodeObjectForKey:@"subjectName"];
        _targetPerson = [aDecoder decodeObjectForKey:@"targetPerson"];
        _cpType = [aDecoder decodeIntegerForKey:@"cpType"];
        _cpAmount = [aDecoder decodeObjectForKey:@"cpAmount"];
        _cpProductID = [aDecoder decodeObjectForKey:@"cpProductID"];
        
    }
    
    return self;
}



@end
