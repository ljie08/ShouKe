//
//  BasicAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/19.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, APIReturnState) {
    API_SUCCESS,
    API_FAILED,
    API_NODATA,
    API_OTHERS,
};

typedef void(^APIReturnBlock)(APIReturnState state,id data,NSString *message);

@interface BasicAPI : NSObject

+(void)requestWithMethodName:(NSString *)method
                        body:(NSDictionary *)body
                    callback:(APIReturnBlock)callback;

+(void)requestDiscoveryWithMethodName:(NSString *)method
                                 body:(NSDictionary *)body
                             callback:(APIReturnBlock)callback;

+(void)requestWithFormWithParameters:(NSDictionary *)param
                         mutipleData:(NSArray *)data
                            callback:(APIReturnBlock)callback;

@end
