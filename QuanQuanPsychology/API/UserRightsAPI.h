//
//  UserRightsAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface UserRightsAPI : BasicAPI

/* 卡片权限 */
+(void)rightForReadCardByPhone:(NSString *)phone
                      courseID:(NSString *)courseID
                      callback:(APIReturnBlock)callback;

/* 激活码验证 */
+(void)verifyActivationCode:(NSString *)code
                      phone:(NSString *)phone
                   courseID:(NSString *)courseID
                   callback:(APIReturnBlock)callback;

@end
