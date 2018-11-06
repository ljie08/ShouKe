//
//  ArchiveHelper.h
//  collection
//
//  Created by Jocelyn on 2018/1/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveHelper : NSObject

+(void)archiveList:(NSArray *)list
            forKey:(NSString *)key
          docePath:(NSString *)path;

+(NSArray *)unarchiveListWithKey:(NSString *)key
                        docePath:(NSString *)path;

+(void)archiveModel:(id)model
             forKey:(NSString *)key
           docePath:(NSString *)path;

+(id)unarchiveModelWithKey:(NSString *)key
                  docePath:(NSString *)path;

+(void)archiveDict:(NSDictionary *)dict
          docePath:(NSString *)path;

+(NSDictionary *)unarchiveDictWithDocePath:(NSString *)path;

@end
