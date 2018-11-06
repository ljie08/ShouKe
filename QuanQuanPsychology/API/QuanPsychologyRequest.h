//
//  QuanDataRequest.h
//  QuanQuan
//
//  Created by Jocelyn on 16/11/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuanPsychologyRequest : NSObject

#pragma mark - Init
/* 初始化单例 */
+(instancetype)sharedInstance;

-(void)postWithSever:(NSString *)sever
          methodName:(NSString *)method
                body:(NSDictionary *)body
             success:(void (^)(NSDictionary *result))success
             failure:(void (^)(NSError *error))failure;

-(void)uploadFormWithParameters:(NSDictionary *)param
                    mutipleData:(NSArray *)data
                        success:(void (^)(NSDictionary *result))success
                        failure:(void (^)(NSError *error))failure;

-(void)cancelRequest;

@end
