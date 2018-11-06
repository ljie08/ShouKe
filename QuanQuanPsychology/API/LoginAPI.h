//
//  LoginAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface LoginAPI : BasicAPI

/* 登录时间 */
+(void)loginDetailWithUID:(NSString *)uid
                 callback:(APIReturnBlock)callback;

/* 手机注册-是否已经注册过  */
+(void)hasRegisterPhone:(NSString *)phone
               callback:(APIReturnBlock)callback;

/* 手机注册-获取验证码  */
+(void)getVerifyCodeWithPhone:(NSString *)phone
                     callback:(APIReturnBlock)callback;

/* 验证验证码 */
+(void)verifyWithPhone:(NSString *)phone
            verifyCode:(NSString *)verifyCode
              callback:(APIReturnBlock)callback;

/* 验证验证码和密码 */
+(void)verifyWithPhone:(NSString *)phone
            verifyCode:(NSString *)verifyCode
              password:(NSString *)password
              callback:(APIReturnBlock)callback;

/* 注册设置密码 */
+(void)registerWithPhone:(NSString *)phone
             andPassword:(NSString *)password
                callback:(APIReturnBlock)callback
            __attribute__((deprecated("QuanQuan 1.7.5 版本已过期")));

/* 忘记密码-重置密码 */
+(void)resetPasswordWithPhone:(NSString *)phone
                  andPassword:(NSString *)password
                   verifyCode:(NSString *)verifyCode
                     callback:(APIReturnBlock)callback;

/* 登录 */
+(void)loginWithPhone:(NSString *)phone
          andPassword:(NSString *)password
            loginType:(NSString *)loginType
             callback:(APIReturnBlock)callback;

/* 上传头像及用户名 */
+(void)uploadUserPortraitWithUID:(NSString *)uid
                           image:(UIImage *)image
                     andUserName:(NSString *)userName
                        callback:(APIReturnBlock)callback;

/* 用户访问页面 */
+(void)countUserViewPageWithUID:(NSString *)uid
                          count:(NSString *)count
                           time:(NSString *)time
                        version:(NSString *)version
                       callback:(APIReturnBlock)callback;

/* 用户是否已经绑定手机 */
+(void)hasBindPhoneWithOpenID:(NSString *)openID
                     nickname:(NSString *)nickname
                        photo:(NSString *)photo
                         type:(NSString *)type
                     callback:(APIReturnBlock)callback;

/* 绑定手机 */
+(void)bindingPhoneWithAuthID:(NSString *)authID
                       uphone:(NSString *)uphone
                   verifyCode:(NSString *)verifyCode
                     password:(NSString *)password
                     callback:(APIReturnBlock)callback;

@end
