//
//  UserModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/15.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        self.uid = dict[UID];
        self.phone = dict[UPHONE];
        self.userName = dict[UNAME];
        self.email = dict[EMAIL];
        self.portrait = dict[AVATAR];
        self.introduce = dict[INTRODUCE];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_uid forKey:@"uid"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_portrait forKey:@"portrait"];
    [aCoder encodeObject:_introduce forKey:@"introduce"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _uid = [aDecoder decodeObjectForKey:@"uid"];
        _phone = [aDecoder decodeObjectForKey:@"phone"];
        _userName = [aDecoder decodeObjectForKey:@"userName"];
        _email = [aDecoder decodeObjectForKey:@"email"];
        _portrait = [aDecoder decodeObjectForKey:@"portrait"];
        _introduce = [aDecoder decodeObjectForKey:@"introduce"];
    }
    
    return self;
}

@end
