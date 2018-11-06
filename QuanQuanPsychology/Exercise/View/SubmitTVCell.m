//
//  SubmitTVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "SubmitTVCell.h"

@implementation SubmitTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)submitAnswer:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(submitButtonClicked:)]) {
        [_delegate submitButtonClicked:sender];
    }
}


@end
