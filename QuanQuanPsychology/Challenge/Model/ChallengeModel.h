//
//  ChallengeModel.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface ChallengeModel : BasicModel

/* 答题过关所需要的正确率 */
@property (copy, nonatomic) NSString *passingRate;

/* 难度系数 */
@property (copy, nonatomic) NSString *difficulty;

/* 用户正确率 */
@property (copy, nonatomic) NSString *accuracy;

/* 当前关卡 */
@property (copy, nonatomic) NSString *currentLevel;

/* 总关卡 */
@property (copy, nonatomic) NSString *totalLevel;

/* 已过关卡 */
@property (copy, nonatomic) NSString *passedLevel;

-(instancetype)initWithDict:(NSDictionary *)dict andMaxLevel:(NSString *)max;

@end
