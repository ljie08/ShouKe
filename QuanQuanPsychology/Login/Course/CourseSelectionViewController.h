//
//  CourseSelectionViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/18.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseSelectionViewController : QQBasicViewController

@property (strong, nonatomic) NSString *regionID;//城市adcode

@property (strong, nonatomic) NSString *regionName;//城市名称

@property (assign, nonatomic) BOOL fromHome;

@end
