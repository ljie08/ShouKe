//
//  CardPackagePayAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackagePayAPI.h"

@implementation CardPackagePayAPI

/* 卡包预下订单 */
+(void)preOrderWithUID:(NSString *)uid
             packageID:(NSString *)packageID
              callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",packageID,@"package_id", nil];
    
    [self requestWithMethodName:@"applePreOrder" body:body callback:callback];
}

/* 订单校验 */
+(void)orderCheckingWithUID:(NSString *)uid
                  packageID:(NSString *)packageID
                    receipt:(NSString *)receipt
                   callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",packageID,@"package_id",receipt,@"data", nil];

    [self requestWithMethodName:@"validateRemotely" body:body callback:callback];
}

/* 卡包付款成功 */
+(void)payOrderWithUID:(NSString *)uid
             packageID:(NSString *)packageID
              callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",packageID,@"package_id", nil];

    [self requestWithMethodName:@"payOrder" body:body callback:callback];
}

@end
