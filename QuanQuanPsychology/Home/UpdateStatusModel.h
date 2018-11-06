//
//  UpdateStatusModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/30.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

typedef NS_ENUM(NSUInteger, QQUpdateModule) {
    QQUM_CardPackage,
    QQUM_Course,
    QQUM_Book,
};

@interface UpdateStatusModel : BasicModel<NSCoding>

@property (strong, nonatomic) NSMutableSet *readSet;

@property (assign, nonatomic) NSString *maxID;

@property (assign, nonatomic) NSString *defaultID;

@property (assign, nonatomic) BOOL hasUnread;

-(void)checkUnreadStatus:(NSArray *)readIDs;

-(void)archiveModel:(UpdateStatusModel *)model forModule:(QQUpdateModule)module;
+(UpdateStatusModel *)unarchiveforModule:(QQUpdateModule)module;

@end
