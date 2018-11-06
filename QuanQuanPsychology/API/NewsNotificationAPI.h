//
//  NewsNotificationAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface NewsNotificationAPI : BasicAPI

/* 我的消息 */
+(void)fetchMyNewsWithUID:(NSString *)uid
                 callback:(APIReturnBlock)callback;

+(void)fetchUnreadMessageWithUID:(NSString *)uid
                        readTime:(NSString *)time
                        callback:(APIReturnBlock)callback;


@end
