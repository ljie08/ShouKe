//
//  DetailCourseCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "DetailCourseCVCell.h"

@implementation DetailCourseCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.courseImage.layer.cornerRadius = 4;
    self.courseImage.layer.masksToBounds = YES;
}

@end
