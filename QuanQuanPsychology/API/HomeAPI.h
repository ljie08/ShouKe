//
//  HomeAPI.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/27.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface HomeAPI : BasicAPI

/* 首页精品课程 */
+(void)fetchHomeRecommendCourseWithCourseID:(NSString *)courseID
                                   callback:(APIReturnBlock)callback;

/* 首页轮播图 */
+(void)fetchBannerImagesWithUID:(NSString *)uid
                       callback:(APIReturnBlock)callback;

/* 首页精品卡包 */
+(void)fetchHomeRecommendCPWithUID:(NSString *)uid
                          courseID:(NSString *)courseID
                          callback:(APIReturnBlock)callback;

/* 首页打卡数据 */
+ (void)fetchPunchCardWithUID:(NSString *)uid
                     callback:(APIReturnBlock)callback;

/* 首页打卡 */
+ (void)savePunchCardWithUID:(NSString *)uid
                    callback:(APIReturnBlock)callback;

@end
