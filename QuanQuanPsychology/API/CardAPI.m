//
//  CardAPI.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardAPI.h"

@implementation CardAPI

/* 学习卡片 */
+(void)fetchCardsWithID:(NSString *)ID
                    uid:(NSString *)uid
               callback:(APIReturnBlock)callback{
    
//    NSString *method = @"";
//    NSString *IDString = @"";
//
//    if (isCardPackage) {
//        method = @"getCardPackageCardsByCPId";
//        IDString = @"cp_id";
//    } else {
//        method = ;
//        IDString = ;
//    }
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:
                          ID,@"cp_id",
                          uid,@"uid",
                          nil];
    
    [self requestWithMethodName:@"getCardPackageCardsByCPId" body:body callback:callback];
    
}

/* 练习题目 */
+(void)fetchQuesWithCardID:(NSString *)cardID
                       uid:(NSString *)uid
                  callback:(APIReturnBlock)callback{
    
    NSDictionary *body = [NSDictionary dictionaryWithObjectsAndKeys:cardID,@"card_id", uid, @"uid", nil];

//    NSString *method = @"";
//    uid
//    if (isCardPackage) {
//        method = @"getCardPackageQuestionByCardId";
//    } else {
//        method = @"getQuestionByCardId";
//    }
    
    [self requestWithMethodName:@"getCardPackageQuestionByCardId" body:body callback:callback];
    
}

@end
