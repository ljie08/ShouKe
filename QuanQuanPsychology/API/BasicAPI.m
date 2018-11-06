//
//  BasicAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/19.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"
#import <CommonCrypto/CommonDigest.h>
#import "QuanPsychologyRequest.h"

#define QUAN_API      [SEVER_QUAN_API stringByAppendingString:@"service/supe/savehuman"]
//#define QUAN_LIVE     [SEVER_QUAN_LIVE stringByAppendingString:@"service/supe/savehuman"]


@implementation BasicAPI

+(void)requestWithMethodName:(NSString *)method body:(NSDictionary *)body callback:(APIReturnBlock)callback{
    
    NSDictionary *secureBody = [self addTokenFromBody:body];
    
//    NSLog(@"%@",secureBody);
    
    NSDictionary *params = @{@"req_method": method,
                             @"req_body": secureBody};
    
    [[QuanPsychologyRequest sharedInstance] postWithSever:QUAN_API methodName:method body:params success:^(NSDictionary *result) {
        NSString *status = result[STATUS];
        NSString *msg = result[MSG];
        APIReturnState state = API_OTHERS;
        if ([status isEqualToString:SUCCESS]) {
            state = API_SUCCESS;
        } else if ([status isEqualToString:NODATA]){
            state = API_NODATA;
        }
        callback(state,result,msg);
    } failure:^(NSError *error) {
        callback(API_FAILED,nil,error.localizedDescription);
    }];

}

+(void)requestDiscoveryWithMethodName:(NSString *)method body:(NSDictionary *)body callback:(APIReturnBlock)callback{
    
    NSDictionary *secureBody = [self addTokenFromBody:body];
    
    NSDictionary *params = @{@"req_method": method,
                             @"req_body": secureBody};
    
    [[QuanPsychologyRequest sharedInstance] postWithSever:QUAN_API methodName:method body:params success:^(NSDictionary *result) {
        NSString *status = result[STATUS];
        NSString *msg = result[MSG];
        APIReturnState state = API_OTHERS;
        if ([status isEqualToString:SUCCESS]) {
            state = API_SUCCESS;
        } else if ([status isEqualToString:NODATA]){
            state = API_NODATA;
        }
        callback(state,result,msg);
    } failure:^(NSError *error) {
        callback(API_FAILED,nil,error.localizedDescription);
    }];
    
}

+(void)requestWithFormWithParameters:(NSDictionary *)param
                         mutipleData:(NSArray *)data
                            callback:(APIReturnBlock)callback{
    [[QuanPsychologyRequest sharedInstance] uploadFormWithParameters:param mutipleData:data success:^(NSDictionary *result) {
        NSString *status = result[STATUS];
        NSString *msg = result[MSG];
        APIReturnState state = API_OTHERS;
        if ([status isEqualToString:SUCCESS]) {
            state = API_SUCCESS;
        } else if ([status isEqualToString:NODATA]){
            state = API_NODATA;
        }
        callback(state,result,msg);
    } failure:^(NSError *error) {
        callback(API_FAILED,nil,error.localizedDescription);
    }];
}

#pragma mark - MD5加密
+(NSString *)md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return  output;
}

+(NSDictionary *)addTokenFromBody:(NSDictionary *)dict{
    
    NSMutableDictionary *body = [dict mutableCopy];
    
    [body setValue:@"FZ66613F" forKey:@"key"];
    
    NSArray *keys = [body allKeys];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    
    NSArray *sortedKeys = [keys sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    NSString *token = @"";
    
    for (int i = 0; i < sortedKeys.count; i++) {
        
        id value = [body valueForKey:sortedKeys[i]];
        
        if (![value isKindOfClass:[NSArray class]]) {
            token = [token stringByAppendingString:sortedKeys[i]];
            token = [token stringByAppendingString:@"="];
            token = [token stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
            
            if (i != sortedKeys.count - 1 ) {
                token = [token stringByAppendingString:@"&"];
            }
        }
        
    }
    
    NSString *secureBody = [self md5:token];
    
    if (![keys containsObject:@"token"]) {
        [body setValue:secureBody forKey:@"token"];
        [body removeObjectForKey:@"key"];
    }
    
    return [body copy];
}

@end
