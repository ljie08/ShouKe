//
//  UserView.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/15.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserView : UIView

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *item;

-(void)initWithIcon:(UIImage *)image item:(NSString *)item;

@end
