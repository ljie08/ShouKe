//
//  UserTypeCell.m
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserTypeCell.h"

@interface UserTypeCell()

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UIButton *courseBtn;
@property (weak, nonatomic) IBOutlet UIButton *mistakesBtn;

@end

@implementation UserTypeCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"UserTypeCell";
    UserTypeCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserTypeCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (IBAction)cardAction:(id)sender {
    if (self.cardBlock) {
        self.cardBlock();
    }
}

- (IBAction)courseAction:(id)sender {
    if (self.courseBlock) {
        self.courseBlock();
    }
}

- (IBAction)mistakesAction:(id)sender {
    if (self.misstakeBlock) {
        self.misstakeBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //加阴影
    [self.bgview shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    [self setBtnTitleAntPicWithBtn:self.cardBtn];
    [self setBtnTitleAntPicWithBtn:self.courseBtn];
    [self setBtnTitleAntPicWithBtn:self.mistakesBtn];
}

/**
 设置按钮图片在上，title在下，并居中显示

 @param button 要设置的按钮
 */
- (void)setBtnTitleAntPicWithBtn:(UIButton *)button {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height+10, -button.imageView.frame.size.width, 0.0, 0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [button setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 30.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
