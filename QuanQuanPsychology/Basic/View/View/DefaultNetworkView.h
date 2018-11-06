//
//  DefaultNetworkView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/12.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefaultNetworkView : UIView

@property (copy, nonatomic) void(^refreshView)(void);

@end
