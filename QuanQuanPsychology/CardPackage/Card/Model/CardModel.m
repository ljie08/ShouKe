//
//  CardModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/5/31.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardModel.h"

@implementation CardModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        /*
         "progress": 卡片进度
         "cardId": 卡片ID
         "isComplete": 是否完成
         "cardName": 卡片名称
         "cardPic": 图片路径
         "star": 卡片星级
         "analysis": 卡片解析
         */
        
        self.cardID = dict[CARDID];
        self.cardName = dict[CARDNAME];
        self.cardPic = dict[PICPATH];
        self.cardStar = dict[CARDSTAR];
        self.cardAnalysis = [dict[CARDANALYSIS] stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        
        self.cardProgress = dict[CARDPROGRESS];
        self.cardIsComplete = dict[CARDISCOMPLETE];
        
        NSString *isQues = dict[@"is_question"];
        if ([isQues isEqualToString:@"1"]) {
            self.hasQuestion = YES;
        } else {
            self.hasQuestion = NO;
        }
    }
    
    return self;
}

#pragma mark - <NSCoding>
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_cardID forKey:CARDID];
    [aCoder encodeObject:_cardName forKey:CARDNAME];
    [aCoder encodeObject:_cardPic forKey:PICPATH];
    [aCoder encodeObject:_cardStar forKey:CARDSTAR];
    [aCoder encodeObject:_cardAnalysis forKey:CARDANALYSIS];
    [aCoder encodeObject:_cardProgress forKey:CARDPROGRESS];
    [aCoder encodeObject:_cardIsComplete forKey:CARDISCOMPLETE];
    [aCoder encodeBool:_hasQuestion forKey:@"is_question"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        _cardID = [aDecoder decodeObjectForKey:CARDID];
        _cardName = [aDecoder decodeObjectForKey:CARDNAME];
        _cardPic = [aDecoder decodeObjectForKey:PICPATH];
        _cardStar = [aDecoder decodeObjectForKey:CARDSTAR];
        _cardAnalysis = [aDecoder decodeObjectForKey:CARDANALYSIS];
        _cardProgress = [aDecoder decodeObjectForKey:CARDPROGRESS];
        _cardIsComplete = [aDecoder decodeObjectForKey:CARDISCOMPLETE];
        _hasQuestion = [aDecoder decodeBoolForKey:@"is_question"];

    }
    
    return self;
}

@end
