//
//  CPCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPCVCell.h"
#import "CardPackageModel.h"

@interface CPCVCell()

@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@property (weak, nonatomic) IBOutlet UILabel *cpTitle;

@property (weak, nonatomic) IBOutlet UIImageView *cpDeco;

@property (weak, nonatomic) IBOutlet UIView *cardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cpImage;

@property (weak, nonatomic) IBOutlet UILabel *cpCourseName;

@end

@implementation CPCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.cardInfoView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:6 shadowOpacity:1];
    self.cardInfoView.layer.masksToBounds = NO;
    self.cardInfoView.layer.cornerRadius = 4;
    
    [self.cardImageView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.12 shadowRadius:6 shadowOpacity:1];
    self.cardImageView.layer.masksToBounds = NO;
    self.cardImageView.layer.cornerRadius = 4;
    
    self.layer.masksToBounds = NO;
}

-(void)configureCellWithModel:(CardPackageModel *)model forIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0) {
        self.cpDeco.image = [UIImage imageNamed:@"card_deco_green"];
    } else {
        self.cpDeco.image = [UIImage imageNamed:@"card_deco_red"];
    }
    
    self.cpTitle.text = model.cpTitle;
    [self.cpImage sd_setImageWithURL:[QuanUtils fullImagePath:model.cpTitlePic] placeholderImage:[UIImage imageNamed:@"default_cp"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    self.cpCourseName.text = model.courseName;
}

@end
