//
//  ThirdPartyLoginHelper.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface ThirdPartyLoginHelper : NSObject

-(void)getAuthWithUserInfoFrom:(UMSocialPlatformType)socialType
                       success:(void (^)(UMSocialUserInfoResponse *result))userInfo
                       failure:(void (^)(NSError *error))failure;

@end
