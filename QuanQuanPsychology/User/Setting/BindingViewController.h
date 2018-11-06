//
//  BindingViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/1.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "QQBasicViewController.h"

typedef NS_ENUM(NSUInteger, ThirdPartyPlatformType) {
    ThirdPartyPlatformType_Wechat,
    ThirdPartyPlatformType_QQ
};

@interface BindingViewController : QQBasicViewController

@property (assign, nonatomic) ThirdPartyPlatformType platform;

@property (copy, nonatomic) NSString *bindingName;

-(void)updateBindingInfo:(void(^)(NSString *name, ThirdPartyPlatformType platform))name;

@end
