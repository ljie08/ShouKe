//
//  ErrorQuestionAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface ErrorQuestionAPI : BasicAPI

/* 我的错题 */
+(void)fetchMyWrongQuesModuleWithUID:(NSString *)uid
                            courseID:(NSString *)courseID
                            callback:(APIReturnBlock)callback;

/* 删除我的错题 */
+(void)deleteMyWrongQuesWithQuesID:(NSString *)quesID
                          callback:(APIReturnBlock)callback;

@end
