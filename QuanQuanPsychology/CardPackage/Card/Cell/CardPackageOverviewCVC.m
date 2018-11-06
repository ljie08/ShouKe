//
//  CardPackageOverviewCVC.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/4.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageOverviewCVC.h"

@implementation CardPackageOverviewCVC

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initUI];
}

-(void)initUI{
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor colorwithHexString:@"#c8c8c8"].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    
    self.basicView.layer.cornerRadius = 5.0f;
    
    self.cardImage.layer.masksToBounds = YES;
    
}

-(void)setValueWithModel:(CardModel *)card{
    self.cardName.text = card.cardName;
    
    self.cardName.adjustsFontSizeToFitWidth = YES;
    
    [self.cardImage sd_setImageWithURL:[QuanUtils fullImagePath:card.cardPic] placeholderImage:[UIImage imageNamed:@"精编知识卡默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.cardImage.layer.masksToBounds = YES;
        
        self.cardImage.layer.mask = [QuanUtils addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(5.0, 5.0) viewRect:self.cardImage.bounds];
        
    }];
//    [self.cardImage sd_setImageWithURL:[GlobalFunction fullImagePath:card.cardPic]];
}

@end
