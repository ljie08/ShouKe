//
//  CardStudyInfoView.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardStudyInfoView : UIView

@property (strong, nonatomic) UILabel *number;

@property (strong, nonatomic) UILabel *item;

-(void)updateNumber:(NSString *)number unit:(NSString *)unit item:(NSString *)item;

@end
