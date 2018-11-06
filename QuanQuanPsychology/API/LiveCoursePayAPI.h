//
//  LiveCoursePayAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/28.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface LiveCoursePayAPI : BasicAPI

/* 直播课订单校验 */
+(void)orderCheckingliveCourseOrderID:(NSString *)liveCourseID
                              receipt:(NSString *)receipt
                             callback:(APIReturnBlock)callback;

@end
