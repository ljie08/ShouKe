//
//  ChallengeAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface ChallengeAPI : BasicAPI

/* 用户当前挑战的级别*/
+(void)fetchUserChallengeLevelWithUID:(NSString *)uid
                             courseID:(NSString *)courseID
                             callback:(APIReturnBlock)callback;

/* 用户挑战通过 */
+(void)challengePassedWithUID:(NSString *)uid
                     courseID:(NSString *)courseID
                        level:(NSString *)level
                     accuracy:(NSString *)accuracy
                     callback:(APIReturnBlock)callback;


/* 发送级别 获取对应的题干 选项 */
+(void)fetchChallengeQuesWithUID:(NSString *)uid
                        courseID:(NSString *)courseID
                           level:(NSString *)level
                        callback:(APIReturnBlock)callback;

@end
