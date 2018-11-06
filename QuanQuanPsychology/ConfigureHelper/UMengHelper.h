//
//  UMSocialHelper.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/10.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMengHelper : NSObject

+(void)configUMobClick;

+(void)configUSharePlatforms;

+(void)openLog:(BOOL)open;

+(BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

