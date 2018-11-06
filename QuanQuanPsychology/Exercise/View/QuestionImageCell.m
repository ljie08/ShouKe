//
//  QuestionImageCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/9/7.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "QuestionImageCell.h"

@implementation QuestionImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureCellWithModel:(QuestionModel *)question{
    
    NSString *path = question.titleURL;
    
    [self.questionImage sd_setImageWithURL:[QuanUtils fullImagePath:path] placeholderImage:[UIImage imageNamed:@"题目默认图"]];
}

@end
