//
//  VideoRecordModel.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "VideoRecordModel.h"

@implementation VideoRecordModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.p_name = dict[@"p_name"];
        self.course_id = dict[@"course_id"];
        self.v_id = dict[@"id"];
        self.complete_time = dict[@"complete_time"];
        self.title = dict[@"title"];
        self.play_background_pic_url = dict[@"play_background_pic_url"];
        self.NAME = dict[@"NAME"];
        self.pid = dict[@"pid"];
    }
    return self;
}

@end
