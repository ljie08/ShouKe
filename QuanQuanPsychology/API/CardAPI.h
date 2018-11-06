//
//  CardAPI.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/20.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicAPI.h"

@interface CardAPI : BasicAPI

/* 学习卡片 */
+(void)fetchCardsWithID:(NSString *)ID
                    uid:(NSString *)uid
               callback:(APIReturnBlock)callback;

/* 练习题目 */
+(void)fetchQuesWithCardID:(NSString *)cardID
                       uid:(NSString *)uid
                  callback:(APIReturnBlock)callback;

@end
