//
//  CardModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/31.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface CardModel : BasicModel <NSCoding>

@property (strong, nonatomic) NSString *cardID;

@property (strong, nonatomic) NSString *cardName;

@property (strong, nonatomic) NSString *cardPic;

@property (strong, nonatomic) NSString *cardStar;

@property (strong, nonatomic) NSString *cardAnalysis;

@property (strong, nonatomic) NSString *cardProgress;

@property (strong, nonatomic) NSString *cardIsComplete;

@property (assign, nonatomic) BOOL hasQuestion;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
