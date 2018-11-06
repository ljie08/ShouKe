//
//  EventAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface EventAPI : BasicAPI

/* 活动信息 */
+(void)fetchEventDetailWithCourseID:(NSString *)courseID
                           callback:(APIReturnBlock)callback;

/* 邀请活动分享是否成功 */
+(void)isShareSuccessWithUID:(NSString *)uid
                    courseID:(NSString *)courseID
                     eventID:(NSString *)eventID
                    callback:(APIReturnBlock)callback;

/* 激活邀请状态 */
+(void)activeInvitationStatusWithUID:(NSString *)uid
                               phone:(NSString *)phone
                            courseID:(NSString *)courseID
                            callback:(APIReturnBlock)callback;

/* 查询弹窗 */
+(void)checkPopupwithCourseID:(NSString *)courseID
                     callback:(APIReturnBlock)callback;

@end
