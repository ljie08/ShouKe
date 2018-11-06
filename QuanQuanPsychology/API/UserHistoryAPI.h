//
//  UserHistoryAPI.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/8.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface UserHistoryAPI : BasicAPI

/* 观看历史 */
+(void)fetchUserHistoryWithUID:(NSString *)uid
                          callback:(APIReturnBlock)callback;

@end
