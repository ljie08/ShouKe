//
//  PopupModel.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/17.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "PopupModel.h"

@implementation PopupModel

//#pragma mark - <NSCoding>
//-(void)encodeWithCoder:(NSCoder *)aCoder{
////    [aCoder encodeObject:_popupCourse forKey:@"popup_course"];
//    [aCoder encodeObject:_popupTime forKey:@"popup_time"];
//    [aCoder encodeObject:_popupStartTime forKey:@"popup_start_time"];
//    [aCoder encodeObject:_popupEndTime forKey:@"popup_end_time"];
//}
//
//-(instancetype)initWithCoder:(NSCoder *)aDecoder{
//    
//    if (self = [super init]) {
////        _popupCourse = [aDecoder decodeObjectForKey:@"popup_course"];
//        _popupTime = [aDecoder decodeObjectForKey:@"popup_time"];
//        _popupStartTime = [aDecoder decodeObjectForKey:@"popup_start_time"];
//        _popupEndTime = [aDecoder decodeObjectForKey:@"popup_end_time"];
//    }
//    
//    return self;
//}

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    
    if (self) {
        NSString *start = dict[@"start_time"];
        NSString *end = dict[@"end_time"];
        
        self.popupStartTime = [start componentsSeparatedByString:@"."].firstObject;
        self.popupEndTime = [end componentsSeparatedByString:@"."].firstObject;
        self.url = dict[@"link_url"];
        self.imagePath = dict[@"pic_path"];
    }
    
    return self;
}

@end
