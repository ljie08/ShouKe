//
//  QuanDataRequest.m
//  QuanQuan
//
//  Created by Jocelyn on 16/11/8.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "QuanPsychologyRequest.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+Extensions.h"

#define APIMETHOD @"req_method"
#define APIBODY @"req_body"
#define QUAN_IMAGEUPLOAD [SEVER_QUAN_API stringByAppendingString:@"picUpload"]


@interface QuanPsychologyRequest()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation QuanPsychologyRequest

#pragma mark - Init
+(instancetype)sharedInstance{
    static QuanPsychologyRequest *dataRequest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataRequest = [[QuanPsychologyRequest alloc] init];
    });
    return dataRequest;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
//        [self.manager.requestSerializer setTimeoutInterval:30];
    }
    return self;
}

#pragma mark - POST
-(void)postWithSever:(NSString *)sever
          methodName:(NSString *)method
                body:(NSDictionary *)body
             success:(void (^)(NSDictionary *result))success
             failure:(void (^)(NSError *error))failure{
    
    [self.manager POST:sever parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@ = %@",method,result);
        success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

#pragma mark - FORM
-(void)uploadFormWithParameters:(NSDictionary *)param
                    mutipleData:(NSArray *)data
                        success:(void (^)(NSDictionary *result))success
                        failure:(void (^)(NSError *error))failure{
    
    [self.manager POST:QUAN_IMAGEUPLOAD parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSArray *keys = param.allKeys;
        
        for (int i = 0; i < keys.count; i++) {
            NSString *value = [param valueForKey:keys[i]];
            
            value = [value disableEmojiString];
    
            [formData appendPartWithFormData:[value dataUsingEncoding:NSUTF8StringEncoding] name:keys[i]];
            
        }
        
        for (int i = 0; i < data.count; i++) {
            
            UIImage *image = data[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            NSString *timeCode = [NSDate creatTimeCode];
            
            NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg",timeCode,i + 1];
            
            [formData appendPartWithFileData:imageData name:@"upload" fileName:fileName mimeType:@"image/jpg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"form result = %@",result);
        success(result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

-(void)cancelRequest{
    [self.manager.operationQueue cancelAllOperations];
}

@end
