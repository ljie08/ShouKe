//
//  CardPackageModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/27.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageModel.h"

#define TITLEPIC @"title_pic"
#define SUBTITLE @"title"
#define OWNCARDPACKAGE @"haveCardPackage"

@interface CardPackageModel()

@end


@implementation CardPackageModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        
        self.ownCardPackage = [dict[@"haveCardPackage"] boolValue];
        self.courseName = dict[EXAMNAME];
        self.courseLevel = dict[EXAMGRADE];
        self.cpOwners = [NSString stringWithFormat:@"%@",dict[@"cardPackageCount"]];
        self.cpID = [NSString stringWithFormat:@"%@",dict[CARDPACKAGEID]];
        self.cpTitle = dict[CARDPACKAGETITLE];
        self.cpTitlePic = dict[TITLEPIC];
        self.cpSubTitle = [dict[SUBTITLE] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        NSString *type =[NSString stringWithFormat:@"%@",dict[@"type"]];
        
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
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:_ownCardPackage forKey:@"ownCardPackage"];
    [aCoder encodeObject:_courseName forKey:@"courseName"];
    [aCoder encodeObject:_courseLevel forKey:@"courseLevel"];
    [aCoder encodeObject:_cpOwners forKey:@"cpOwners"];
    [aCoder encodeObject:_cpID forKey:@"cardPackageID"];
    [aCoder encodeObject:_cpTitle forKey:@"cardPackageTitle"];
    [aCoder encodeObject:_cpTitlePic forKey:@"cardPackageTitlePic"];
    [aCoder encodeObject:_cpSubTitle forKey:@"cardPackageSubTitle"];
    [aCoder encodeInteger:_cpType forKey:@"cpType"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _ownCardPackage = [aDecoder decodeBoolForKey:@"ownCardPackage"];
        _courseName = [aDecoder decodeObjectForKey:@"courseName"];
        _courseLevel = [aDecoder decodeObjectForKey:@"courseLevel"];
        _cpOwners = [aDecoder decodeObjectForKey:@"cpOwners"];
        _cpID = [aDecoder decodeObjectForKey:@"cardPackageID"];
        _cpTitle = [aDecoder decodeObjectForKey:@"cardPackageTitle"];
        _cpTitlePic = [aDecoder decodeObjectForKey:@"cardPackageTitlePic"];
        _cpSubTitle = [aDecoder decodeObjectForKey:@"cardPackageSubTitle"];
        _cpType = [aDecoder decodeIntegerForKey:@"cpType"];
        
    }
    
    return self;
}

@end
