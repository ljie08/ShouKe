//
//  ActivationCodeView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/6.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivationCodeView : UIView

@property (copy, nonatomic) void(^buy)(UIButton *button);

@property (copy, nonatomic) void(^cancel)(UIButton *button);


-(void)removeActivationView;

@end
