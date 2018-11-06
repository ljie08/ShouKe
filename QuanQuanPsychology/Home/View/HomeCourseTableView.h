//
//  HomeCourseTableView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/20.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoCourseModel;

@interface HomeCourseTableView : UITableView

@property (strong, nonatomic) NSArray *courseLists;

@property (copy, nonatomic) void(^didSelectRowAtIndexPath)(UITableView *tableView, NSIndexPath *indexPath, VideoCourseModel *course);

@property (copy, nonatomic) void(^didClickMoreCourseButton)(UIButton *button);

@end
