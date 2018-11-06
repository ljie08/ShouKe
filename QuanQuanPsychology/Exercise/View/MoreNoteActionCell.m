//
//  MoreNoteActionCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/8.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "MoreNoteActionCell.h"

@implementation MoreNoteActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateBtnStatus:(BOOL)hasNote{
    if (hasNote) {
        [self.button setTitle:@"还有疑问？试试问问其他人" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor customisLightGreyColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:12];
        self.button.titleLabel.attributedText = [QuanUtils formatText:self.button.titleLabel.text withAttributedText:@"试试问问其他人" color:[UIColor colorwithHexString:@"#638FC2"] font:[UIFont systemFontOfSize:12]];
        self.button.tag = 101;
    } else {
        [self.button setTitle:@"还没有人添加过笔记，去试试～" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor customisLightGreyColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont systemFontOfSize:14];
        self.button.titleLabel.attributedText = [QuanUtils formatText:self.button.titleLabel.text withAttributedText:@"去试试" color:[UIColor colorwithHexString:@"#638FC2"] font:[UIFont systemFontOfSize:14]];
        self.button.tag = 102;
    }
}

- (IBAction)moreAction:(UIButton *)sender {
//    if ([_delegate respondsToSelector:@selector(moreActionButtonClick:)]) {
//        [_delegate moreActionButtonClick:sender];
//    }
}
@end
