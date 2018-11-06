//
//  UpdateStatusModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/30.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "UpdateStatusModel.h"
#import "ArchiveHelper.h"

@implementation UpdateStatusModel

#pragma mark - <NSCoding>
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_readSet forKey:@"readSet"];
    [aCoder encodeObject:_maxID forKey:@"maxID"];
    [aCoder encodeObject:_defaultID forKey:@"defaultID"];
    [aCoder encodeBool:_hasUnread forKey:@"hasUnread"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _readSet = [aDecoder decodeObjectForKey:@"readSet"];
        _maxID = [aDecoder decodeObjectForKey:@"maxID"];
        _defaultID = [aDecoder decodeObjectForKey:@"defaultID"];
        _hasUnread = [aDecoder decodeBoolForKey:@"hasUnread"];

    }
    
    return self;
}

-(NSMutableSet *)readSet{
    if (!_readSet) {
        _readSet = [NSMutableSet set];
    }
    return _readSet;
}

-(void)checkUnreadStatus:(NSArray *)readIDs{
    
    for (int i = 0; i < readIDs.count; i++) {
        NSString *readID = readIDs[i];
        if ([self.readSet containsObject:readID]) {
            self.hasUnread = NO;
        } else {
            self.hasUnread = YES;
        }
    }
}

-(void)archiveModel:(UpdateStatusModel *)model forModule:(QQUpdateModule)module{
    
    NSString *key = [self keyForArchiveModule:module];
    
    NSString *docePath = key;
    
    if (module != QQUM_Course) {
        docePath = [key stringByAppendingString:USERCOURSE];
    }
    
    
    [ArchiveHelper archiveModel:model forKey:key docePath:docePath];
}

+(UpdateStatusModel *)unarchiveforModule:(QQUpdateModule)module{
    
    NSString *key;
    
    switch (module) {
        case QQUM_Book:
            key = @"UpdateStatusModel_Book";
            break;
            
        case QQUM_Course:
            key = @"UpdateStatusModel_Course";
            break;
            
        case QQUM_CardPackage:
            key = @"UpdateStatusModel_CardPackage";
            break;
    }
    
    NSString *docePath = key;
    
    if (module != QQUM_Course) {
        docePath = [key stringByAppendingString:USERCOURSE];
    }
    UpdateStatusModel *model = [ArchiveHelper unarchiveModelWithKey:key docePath:docePath];
    
    return model;
}

-(NSString *)keyForArchiveModule:(QQUpdateModule)module{
    
    switch (module) {
        case QQUM_Book:
            return @"UpdateStatusModel_Book";
            break;
            
        case QQUM_Course:
            return @"UpdateStatusModel_Course";
            break;
            
        case QQUM_CardPackage:
            return @"UpdateStatusModel_CardPackage";
            break;
    }
}


@end
