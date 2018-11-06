//
//  WebInteractionHelper.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/20.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "WebInteractionHelper.h"

#define DiscoveryParam @"%@%suid=%@&exam_id=%@&type=ios&version=%@"

@implementation WebInteractionHelper

+(NSString *)formatDiscoveryURLWithCurrentURL:(NSString *)currentURL{
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *url = @"";
    if ([currentURL containsString:@"?"]) {
        url = [NSString stringWithFormat:DiscoveryParam,currentURL,"&",USERUID,USERCOURSE,version];
    } else {
        url = [NSString stringWithFormat:DiscoveryParam,currentURL,"?",USERUID,USERCOURSE,version];
    }
    
    return url;
}

@end
