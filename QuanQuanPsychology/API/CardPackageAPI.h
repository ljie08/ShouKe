//
//  CardPackageAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface CardPackageAPI : BasicAPI

/* 获取大卡包列表 */
+(void)fetchCPTotalListWithUID:(NSString *)uid
                      courseID:(NSString *)courseID
                          type:(NSString *)type//1 全部 2 我的
                      callback:(APIReturnBlock)callback;

/* 获取我的卡包列表 */
+(void)fetchCardPackageWithUID:(NSString *)uid
                          cpID:(NSString *)cpID
                      callback:(APIReturnBlock)callback;

/* 获取我的卡包详情 */
+(void)fetchCardPackageDetailWithUID:(NSString *)uid
                            courseID:(NSString *)courseID
                           packageID:(NSString *)packageID
                            callback:(APIReturnBlock)callback;

/* 发送用户卡包所做题目 */
+(void)sendCardPackageExerciseQuestionWithUID:(NSString *)uid
                                       cardID:(NSString *)cardID
                                     quesList:(NSArray *)quesList
                                     callback:(APIReturnBlock)callback;

/* 卡包学习卡数统计 */
+(void)fetchCPTotalCardsWithUID:(NSString *)uid
                           cpID:(NSString *)cpID
                       callback:(APIReturnBlock)callback;

@end
