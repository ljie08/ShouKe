//
//  LoginAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "LoginAPI.h"

@implementation LoginAPI

/* 登录时间 */
+(void)loginDetailWithUID:(NSString *)uid
                 callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",nil];

    [self requestWithMethodName:@"saveUserLoginDetail" body:body callback:callback];
}

/* 手机注册-是否已经注册过  */
+(void)hasRegisterPhone:(NSString *)phone
               callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"uphone",nil];
    
    [self requestWithMethodName:@"isAlreadyRegister" body:body callback:callback];
}

/* 手机注册-获取验证码  */
+(void)getVerifyCodeWithPhone:(NSString *)phone
                     callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"uphone",nil];

    [self requestWithMethodName:@"getMessageCode" body:body callback:callback];
}

/* 验证验证码 */
+(void)verifyWithPhone:(NSString *)phone
            verifyCode:(NSString *)verifyCode
              callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          phone,@"uphone",
                          verifyCode,@"code",
                          nil];

    
    [self requestWithMethodName:@"checkCode" body:body callback:callback];
    
}

/* 验证验证码和密码 */
+(void)verifyWithPhone:(NSString *)phone
            verifyCode:(NSString *)verifyCode
              password:(NSString *)password
              callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          phone,@"uphone",
                          verifyCode,@"code",
                          password,@"password",
                          nil];

    [self requestWithMethodName:@"registerNew" body:body callback:callback];
    
}

/* 注册设置密码 */
+(void)registerWithPhone:(NSString *)phone
             andPassword:(NSString *)password
                callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:phone,@"uphone",password,@"password",nil];

    [self requestWithMethodName:@"register" body:body callback:callback];
    
}

/* 忘记密码-重置密码 */
+(void)resetPasswordWithPhone:(NSString *)phone
                  andPassword:(NSString *)password
                   verifyCode:(NSString *)verifyCode
                     callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          phone,@"uphone",
                          verifyCode,@"code",
                          password,@"password",
                          nil];

    [self requestWithMethodName:@"resetPasswordNew" body:body callback:callback];
}

/* 登录 */
+(void)loginWithPhone:(NSString *)phone andPassword:(NSString *)password loginType:(NSString *)loginType callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          phone,@"uphone",
                          loginType,@"loginType",
                          password,@"upwd",
                          nil];

    [self requestWithMethodName:@"login" body:body callback:callback];
    
}

/* 上传头像及用户名 */
+(void)uploadUserPortraitWithUID:(NSString *)uid
                           image:(UIImage *)image
                     andUserName:(NSString *)userName
                        callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"registerPic",@"type",
                          uid,@"uid",
                          userName,@"uname",
                          nil];

    if (image == nil) {
        [self requestWithFormWithParameters:body mutipleData:nil callback:callback];
    } else {
        NSArray *data = @[image];
        [self requestWithFormWithParameters:body mutipleData:data callback:callback];
    }
    
}

/* 用户访问页面 */
+(void)countUserViewPageWithUID:(NSString *)uid
                          count:(NSString *)count
                           time:(NSString *)time
                      version:(NSString *)version
                       callback:(APIReturnBlock)callback{
        
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          count,@"click_num",
                          time,@"click_date",
                          version,@"version",
                          @"1",@"client",
                          nil];

    [self requestWithMethodName:@"savePageView" body:body callback:callback];
    
}


/* 用户是否已经绑定手机 */
+(void)hasBindPhoneWithOpenID:(NSString *)openID
                     nickname:(NSString *)nickname
                        photo:(NSString *)photo
                         type:(NSString *)type
                     callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          openID,@"openid",
                          nickname,@"nickname",
                          photo,@"photo",
                          type,@"type",
                          nil];
    
    [self requestWithMethodName:@"isAlreadyAuth" body:body callback:callback];
    
}

/* 绑定手机 */
+(void)bindingPhoneWithAuthID:(NSString *)authID
                       uphone:(NSString *)uphone
                   verifyCode:(NSString *)verifyCode
                     password:(NSString *)password
                     callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          authID,@"auth_id",
                          uphone,@"uphone",
                          verifyCode,@"code",
                          password,@"password",
                          nil];
    
    [self requestWithMethodName:@"bindUphone" body:body callback:callback];
    
}

@end
