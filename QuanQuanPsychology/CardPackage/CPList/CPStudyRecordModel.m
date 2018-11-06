//
//  CPStudyRecordModel.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/24.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPStudyRecordModel.h"

@implementation CPStudyRecordModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_cp forKey:@"cp"];
    [aCoder encodeObject:_cardID forKey:@"cardID"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _cp = [aDecoder decodeObjectForKey:@"cp"];
        _cardID = [aDecoder decodeObjectForKey:@"cardID"];
        
    }
    
    return self;
}

@end
