//
//  UserInfoAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface UserInfoAPI : BasicAPI

/* 获取用户信息 */
+(void)fetchUserInfoByUID:(NSString *)uid
                 callback:(APIReturnBlock)callback;

/* 修改头像 */
+(void)changeUserPortraitWithUID:(NSString *)uid
                           image:(UIImage *)image
                        callback:(APIReturnBlock)callback;

/* 修改用户名 */
+(void)changeUserName:(NSString *)userName
              withUID:(NSString *)uid
             callback:(APIReturnBlock)callback;

/* 修改简介 */
+ (void)changeUserIntroduce:(NSString *)introduce
                        uid:(NSString *)uid
                   callback:(APIReturnBlock)callback;

/* 修改手机号 */
+(void)changePhoneWithUID:(NSString *)uid
                 newPhone:(NSString *)newPhone
               verifyCode:(NSString *)verifyCode
                 callback:(APIReturnBlock)callback;

/* 修改邮箱 */
+(void)changeEmail:(NSString *)email
           withUID:(NSString *)uid
          callback:(APIReturnBlock)callback;

/* 修改密码 */
+(void)changePassword:(NSString *)oldPassword
      withNewPassword:(NSString *)newPassword
               andUID:(NSString *)uid
             callback:(APIReturnBlock)callback;

/* 意见反馈 */
+(void)sendFeedbackWithUID:(NSString *)uid
                  courseID:(NSString *)courseID
                   content:(NSString *)content
                     image:(UIImage *)image
                  callback:(APIReturnBlock)callback;

/* 微信 QQ 登录授权 */
+(void)saveSocialPlatformAuthWithUID:(NSString *)uid
                              openID:(NSString *)openID
                            nickname:(NSString *)nickname
                           photoPath:(NSString *)photoPath
                                type:(NSString *)type
                            callback:(APIReturnBlock)callback;

/* 获取授权信息 */
+(void)getSocialAuthInfoWithUID:(NSString *)uid
                           type:(NSString *)type
                       callback:(APIReturnBlock)callback;

@end
