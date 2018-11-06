//
//  UserInfoAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "UserInfoAPI.h"

@implementation UserInfoAPI

/* 获取用户信息 */
+(void)fetchUserInfoByUID:(NSString *)uid
                 callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          nil];
    
    [self requestWithMethodName:@"getPersonalInformation" body:body callback:callback];
    
}

/* 修改头像 */
+(void)changeUserPortraitWithUID:(NSString *)uid
                           image:(UIImage *)image
                        callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"head",@"type",
                          uid,@"uid",
                          nil];
    
    NSArray *data = [NSArray arrayWithObjects:image, nil];
    [self requestWithFormWithParameters:body mutipleData:data callback:callback];
}

/* 修改用户名 */
+(void)changeUserName:(NSString *)userName
              withUID:(NSString *)uid
             callback:(APIReturnBlock)callback {
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          userName,@"uname",
                          nil];
    [self requestWithMethodName:@"editUserName" body:body callback:callback];
    
}

/* 修改简介 */
+ (void)changeUserIntroduce:(NSString *)introduce
                        uid:(NSString *)uid
                   callback:(APIReturnBlock)callback {
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          introduce,@"introduce",
                          nil];
    [self requestWithMethodName:@"editIntroduce" body:body callback:callback];
}

/* 修改手机号 */
+(void)changePhoneWithUID:(NSString *)uid
                 newPhone:(NSString *)newPhone
               verifyCode:(NSString *)verifyCode
                 callback:(APIReturnBlock)callback {
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          newPhone,@"uphone",
                          verifyCode,@"code",
                          nil];
    
    [self requestWithMethodName:@"editPhone" body:body callback:callback];
    
}

/* 修改邮箱 */
+(void)changeEmail:(NSString *)email withUID:(NSString *)uid callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          email,@"email",
                          nil];
    
    [self requestWithMethodName:@"editEmail" body:body callback:callback];
}

/* 修改密码 */
+(void)changePassword:(NSString *)oldPassword
      withNewPassword:(NSString *)newPassword
               andUID:(NSString *)uid
             callback:(APIReturnBlock)callback {
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          oldPassword,@"oldPass",
                          newPassword,@"newPass",
                          nil];
    
    [self requestWithMethodName:@"editPassword" body:body callback:callback];
    
}

/* 意见反馈 */
+(void)sendFeedbackWithUID:(NSString *)uid
                  courseID:(NSString *)courseID
                   content:(NSString *)content
                     image:(UIImage *)image
                  callback:(APIReturnBlock)callback{
    
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"feedback",@"type",
                          uid,@"uid",
                          courseID,@"exam_id",
                          content,@"content",
                          nil];
    
    NSArray *data = [NSArray arrayWithObjects:image, nil];
    
    [self requestWithFormWithParameters:body mutipleData:data callback:callback];
}

/* 微信 QQ 登录授权 */
+(void)saveSocialPlatformAuthWithUID:(NSString *)uid
                              openID:(NSString *)openID
                            nickname:(NSString *)nickname
                           photoPath:(NSString *)photoPath
                                type:(NSString *)type
                            callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          openID,@"openid",
                          nickname,@"nickname",
                          photoPath,@"photo",
                          type,@"type",
                          nil];
    
    [self requestWithMethodName:@"saveAuth" body:body callback:callback];
    
}

/* 获取授权信息 */
+(void)getSocialAuthInfoWithUID:(NSString *)uid
                           type:(NSString *)type
                       callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          uid,@"uid",
                          type,@"type",
                          nil];
    
    [self requestWithMethodName:@"getAuthInfo" body:body callback:callback];
    
}

@end
