//
//  VideoNodeModel.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/25.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "VideoNodeModel.h"

@implementation VideoNodeModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.nodeid = [dict[@"id"] integerValue];
        self.nodeDesc = dict[@"description"];
        self.time_node = dict[@"time_node"];
        self.video_id = dict[@"video_id"];
    }
    return self;
}

@end
