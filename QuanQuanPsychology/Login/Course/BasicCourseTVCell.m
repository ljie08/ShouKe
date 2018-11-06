//
//  BasicCourseTVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "BasicCourseTVCell.h"

@implementation BasicCourseTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, self.frame.size.height - 2)];
    self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 2, 0, 2, self.frame.size.height)];
    view.backgroundColor = [UIColor customisMainColor];
    view.tag = 100;
    [self.selectedBackgroundView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.selectedBackgroundView.frame = CGRectMake(0, 1, self.frame.size.width, self.frame.size.height - 2);
    UIView *view = [self viewWithTag:100];
    view.frame = CGRectMake(self.frame.size.width - 2, 0, 2, self.frame.size.height);
}

@end
