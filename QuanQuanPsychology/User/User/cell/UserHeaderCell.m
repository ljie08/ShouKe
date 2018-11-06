//
//  UserHeaderCell.m
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserHeaderCell.h"

@interface UserHeaderCell()

@property (weak, nonatomic) IBOutlet UIView *bgview;
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *nickLab;
@property (weak, nonatomic) IBOutlet UILabel *jianjieLab;

@end

@implementation UserHeaderCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"UserHeaderCell";
    UserHeaderCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserHeaderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)setDataWithModel:(UserModel *)model {
    [self.headerView sd_setImageWithURL:[QuanUtils fullImagePath:model.portrait] placeholderImage:[UIImage imageNamed:@"default_avater"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [QuanUtils clipViewCornerRadius:self.headerView.frame.size.height / 2 withImage:self.headerView.image andImageView:self.headerView];
    }];
    
    self.nickLab.text = model.userName;
    if ([NSString stringIsNull:model.introduce]) {
        self.jianjieLab.text = @"简介：这里面放一句话简介";
    } else {
        self.jianjieLab.text = model.introduce;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //加阴影
    [self.bgview shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.13 shadowRadius:3 shadowOpacity:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
