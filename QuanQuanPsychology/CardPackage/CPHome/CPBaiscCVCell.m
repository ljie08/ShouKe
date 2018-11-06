//
//  CPBaiscCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPBaiscCVCell.h"
#import "CardPackageModel.h"

@interface CPBaiscCVCell()

@property (weak, nonatomic) IBOutlet UILabel *courseName;

@property (weak, nonatomic) IBOutlet UIImageView *cpImage;

@property (weak, nonatomic) IBOutlet UIImageView *cpDeco;

@property (weak, nonatomic) IBOutlet UILabel *cpTitle;

@end


@implementation CPBaiscCVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.16 shadowRadius:3 shadowOpacity:1];
    self.layer.masksToBounds = NO;
//    self.layer.cornerRadius = 5;
}

-(void)configureCellForIndex:(NSIndexPath *)indexPath withModel:(CardPackageModel *)model{
    
    self.cpTitle.text = model.cpTitle;
    
    [self.cpImage sd_setImageWithURL:[QuanUtils fullImagePath:model.cpTitlePic] placeholderImage:[UIImage imageNamed:@"default_cp"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        self.cpImage.layer.cornerRadius = 4;
//        self.cpImage.layer.masksToBounds = YES;
    }];
    
    
    self.courseName.text = model.courseName;
    
    if (indexPath.row % 2) {
        self.cpDeco.image = [UIImage imageNamed:@"card_deco_green"];
    } else {
        self.cpDeco.image = [UIImage imageNamed:@"card_deco_red"];
    }
    
}

@end
