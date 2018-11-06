//
//  UserModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/15.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface UserModel : BasicModel<NSCoding>

@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *email;

@property (copy, nonatomic) NSString *portrait;

@property (nonatomic, copy) NSString *introduce;/**< <#注释#> */

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
