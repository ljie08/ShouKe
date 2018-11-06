//
//  CardPackagePayAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface CardPackagePayAPI : BasicAPI

/* 卡包预下订单 */
+(void)preOrderWithUID:(NSString *)uid
             packageID:(NSString *)packageID
              callback:(APIReturnBlock)callback;

/* 订单校验 */
+(void)orderCheckingWithUID:(NSString *)uid
                  packageID:(NSString *)packageID
                    receipt:(NSString *)receipt
                   callback:(APIReturnBlock)callback;

/* 卡包付款成功 */
+(void)payOrderWithUID:(NSString *)uid
             packageID:(NSString *)packageID
              callback:(APIReturnBlock)callback;

@end
