//
//  CardParkageCVC.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CardParkageCVC : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@property (weak, nonatomic) IBOutlet UILabel *nameColor;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageTitle;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageSubTitle;

@property (weak, nonatomic) IBOutlet UIView *cardInfoShadow;

@property (weak, nonatomic) IBOutlet UIView *cardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cardPackageImage;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageCourseName;

@property (weak, nonatomic) IBOutlet UILabel *cardPackageCourseLevel;

@property (weak, nonatomic) IBOutlet UIView *cardImageShadow;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *updateIcon;

-(void)configureCellWithModel:(CardPackageModel *)model;
@end
