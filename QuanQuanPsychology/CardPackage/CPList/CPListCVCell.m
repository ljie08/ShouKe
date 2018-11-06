//
//  CPListCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/18.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPListCVCell.h"
#import "CardPackageModel.h"

@interface CPListCVCell()

@property (weak, nonatomic) IBOutlet UIView *basicView;


@property (weak, nonatomic) IBOutlet UIView *cpBasicView;

@property (weak, nonatomic) IBOutlet UILabel *cpCourseName;

@property (weak, nonatomic) IBOutlet UILabel *cpTitle;

@property (weak, nonatomic) IBOutlet UIImageView *cpImage;

@property (weak, nonatomic) IBOutlet UIImageView *decImage;

@property (weak, nonatomic) IBOutlet UIImageView *cpType;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UIView *typeBg;

@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (weak, nonatomic) IBOutlet UILabel *cpSubtitle;

@property (weak, nonatomic) IBOutlet UILabel *cpOwners;

@end

@implementation CPListCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.16 shadowRadius:3 shadowOpacity:1];
//    [self shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
//    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = NO;
    self.basicView.layer.masksToBounds = YES;
    
    self.typeBg.layer.cornerRadius = 10;
    self.typeBg.clipsToBounds = YES;

    [self.cpBasicView shadowOffset:CGSizeMake(0, 1) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    self.cpBasicView.layer.masksToBounds = NO;
    self.cpBasicView.layer.cornerRadius = 4;
}


-(void)configureCellForIndex:(NSIndexPath *)indexPath withModel:(CardPackageModel *)model{
    
    
    self.cpCourseName.text = model.courseName;
    self.cpTitle.text = model.cpTitle;
    
    [self.cpImage sd_setImageWithURL:[QuanUtils fullImagePath:model.cpTitlePic] placeholderImage:[UIImage imageNamed:@"default_cp"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    switch (model.cpType) {
        case CP_Free:
            self.cpType.image = [UIImage imageNamed:@"cardpackage_free"];
            self.typeLab.text = @"免费";
            break;
            
        case CP_Paid:
            self.cpType.image = [UIImage imageNamed:@"cardpackage_pay"];
            self.typeLab.text = @"付费";
            break;
            
        case CP_Share:
            self.cpType.image = [UIImage imageNamed:@"cardpackage_share"];
            self.typeLab.text = @"分享";
            break;
            
        default:
            self.cpType.image = [UIImage imageNamed:@"cardpackage_free"];
            self.typeLab.text = @"免费";
            break;
            
    }
    
    
    self.courseName.text = model.courseName;
    self.cpSubtitle.text = model.cpSubTitle;
    
    self.cpOwners.text = [NSString stringWithFormat:@"%@人已获取",model.cpOwners];
    
    if (indexPath.row % 2 == 0) {
        self.decImage.image = [UIImage imageNamed:@"card_deco_green"];
    } else {
        self.decImage.image = [UIImage imageNamed:@"card_deco_red"];
    }
    
}

@end
