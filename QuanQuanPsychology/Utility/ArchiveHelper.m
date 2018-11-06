//
//  ArchiveHelper.m
//  collection
//
//  Created by Jocelyn on 2018/1/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "ArchiveHelper.h"
#import "SandBoxHelper.h"

@implementation ArchiveHelper

+(void)archiveList:(NSArray *)list
            forKey:(NSString *)key
          docePath:(NSString *)path{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:list forKey:key]; // archivingDate的encodeWithCoder
    [archiver finishEncoding];
    //写入文件
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    [data writeToFile:appendingPath atomically:YES];
    
}

+(NSArray *)unarchiveListWithKey:(NSString *)key
                        docePath:(NSString *)path{
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:appendingPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //获得类
    NSArray *array = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return array;
}

+(void)archiveModel:(id)model
             forKey:(NSString *)key
           docePath:(NSString *)path{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:model forKey:key]; // archivingDate的encodeWithCoder
    [archiver finishEncoding];
    //写入文件
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    [data writeToFile:appendingPath atomically:YES];
    
}

+(id)unarchiveModelWithKey:(NSString *)key
                  docePath:(NSString *)path{
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:appendingPath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    //获得类
    id model = [unarchiver decodeObjectForKey:key];
    [unarchiver finishDecoding];
    
    return model;
}

+(void)archiveDict:(NSDictionary *)dict
          docePath:(NSString *)path{
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    [dict writeToFile:appendingPath atomically:YES];
    
}

+(NSDictionary *)unarchiveDictWithDocePath:(NSString *)path{
    
    NSString *appendingPath = [[SandBoxHelper docPath] stringByAppendingPathComponent:path];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:appendingPath];
    
    return dict;
    
}

@end
