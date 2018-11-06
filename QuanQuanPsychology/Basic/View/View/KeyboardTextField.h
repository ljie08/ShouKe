//
//  KeyboardTextField.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/31.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardTextField : UIView

@property (copy, nonatomic) void(^textShouldSend)(BOOL send, NSString *content);

@end
