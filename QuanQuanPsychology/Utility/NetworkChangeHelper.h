//
//  NetworkChangeHelper.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/9.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkChangeHelper : NSObject

@property (copy, nonatomic) void(^networkChange)(NetworkStatus status);

@property (copy, nonatomic) void(^becameActiveHelper)(void);

@property (copy, nonatomic) void(^resignActiveHelper)(void);

@property (assign, nonatomic, readonly) NetworkStatus currentNetwork;

@end
