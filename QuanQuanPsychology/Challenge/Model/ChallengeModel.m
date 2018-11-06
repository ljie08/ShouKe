//
//  ChallengeModel.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ChallengeModel.h"

@implementation ChallengeModel

-(instancetype)initWithDict:(NSDictionary *)dict andMaxLevel:(NSString *)max{
    self = [super init];
    
    if (self) {
        
        self.totalLevel = max;
        self.passingRate = dict[@"rate"];
        self.currentLevel = [NSString stringWithFormat:@"%@",dict[@"num"]];
        self.difficulty = [NSString stringWithFormat:@"%@",dict[@"star"]];
        self.accuracy = [NSString stringWithFormat:@"%@",dict[@"accuracy"]];
        
    }
    
    return self;
}

@end
