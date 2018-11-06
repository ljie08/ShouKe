//
//  PlatformConfiguration.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/10.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "PlatformConfiguration.h"

#ifdef DEBUG
    BOOL isProduction = NO;
    NSString * const UMMob_AppKey = @"5b441224a40fa34388000077";
    NSString * const JPushSDK_AppKey = @"d00b28b8ae1a5613eae3be0b";
#else
    BOOL isProduction = NO;
    NSString * const UMMob_AppKey = @"5b4411d8b27b0a6a1d0000e5";
    NSString * const JPushSDK_AppKey = @"e3c8fa65582675055553873a";
#endif


NSString * const QQ_AppKey = @"1106957635";
NSString * const QQ_AppSecret = @"2M9YWuzaBklIMATe";
NSString * const Sina_AppKey = @"2700650035";
NSString * const Sina_AppSecret = @"46656158ac3499a074cfc97781a004a2";
NSString * const Wechat_AppKey = @"wxa34ccf646db80a48";
NSString * const Wechat_AppSecret = @"9197f1db8ebd68652e6bc9608bdd7031";
