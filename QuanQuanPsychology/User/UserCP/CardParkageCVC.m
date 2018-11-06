//
//  CardParkageCVC.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardParkageCVC.h"
#import "CardPackageModel.h"

@implementation CardParkageCVC

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.masksToBounds = NO;
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    [self addShadowAndCornerRadius];
}

-(void)configureCellWithModel:(CardPackageModel *)model{
    
    
    self.cardPackageTitle.text = model.cpTitle;
    self.cardPackageSubTitle.text = model.cpSubTitle;
    
    [self.cardPackageImage sd_setImageWithURL:[QuanUtils fullImagePath:model.cpTitlePic] placeholderImage:[UIImage imageNamed:@"卡包列表默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.cardPackageImage.layer.cornerRadius = 4;
        self.cardPackageImage.layer.masksToBounds = YES;
    }];
    
    
    self.cardPackageCourseName.text = model.courseName;
    self.cardPackageCourseLevel.text = model.courseLevel;
    
}


-(void)addShadowAndCornerRadius{
    
    [self.cardInfoView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:6 shadowOpacity:1];
    self.cardInfoView.layer.masksToBounds = NO;
    self.cardInfoView.layer.cornerRadius = 4;
    self.cardInfoShadow.layer.cornerRadius = 4;
    
    [self.cardImageView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.12 shadowRadius:6 shadowOpacity:1];
    self.cardImageView.layer.masksToBounds = NO;
    self.cardImageView.layer.cornerRadius = 4;
    self.cardImageShadow.layer.cornerRadius = 4;
    self.cardPackageImage.layer.cornerRadius = 4;
    self.cardPackageImage.layer.masksToBounds = YES;
    
}

-(void)updateShadowViewStatus:(BOOL)hidden{
    
    self.cardInfoShadow.hidden = hidden;
    self.cardImageShadow.hidden = hidden;
    self.statusLabel.hidden = hidden;
    
    if (hidden) {
        self.nameColor.backgroundColor = [UIColor colorwithHexString:@"#FFCDD2"];
    } else {
        self.cardInfoShadow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.cardImageShadow.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.nameColor.backgroundColor = [UIColor colorwithHexString:@"#5c5c5c"];
    }
}

@end
