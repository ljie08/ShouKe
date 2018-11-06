//
//  CardOverviewImageCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardOverviewImageCVCell.h"

@interface CardOverviewImageCVCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottom;


@end

@implementation CardOverviewImageCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initUI];
    
}

-(void)updateConstraints{
    [super updateConstraints];
    
    self.labelTop.constant = self.frame.size.height * 0.077;
    
    self.imageBottom.constant = self.frame.size.height * 0.092;
}

-(void)initUI{
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor colorwithHexString:@"#c8c8c8"].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    
    self.basicView.layer.cornerRadius = 5.0f;
    
}

-(void)setValueWithModel:(CardModel *)card{
    self.cardName.text = card.cardName;
    [self.cardImage sd_setImageWithURL:[QuanUtils fullImagePath:card.cardPic] placeholderImage:[UIImage imageNamed:@"知识卡默认图"]];
}

@end
