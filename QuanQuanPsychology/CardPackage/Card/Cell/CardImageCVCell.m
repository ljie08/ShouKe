//
//  CardImageCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardImageCVCell.h"

@interface CardImageCVCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottom;

@property (assign, nonatomic) BOOL finished;

@end

@implementation CardImageCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.basicCardView.layer.cornerRadius = 10;

}

-(void)updateConstraints{
    [super updateConstraints];
    
    self.starTop.constant = self.frame.size.height * 0.163;

    self.imageBottom.constant = self.frame.size.height * 0.163;
}

#pragma mark - override
-(void)setUIStatus:(BOOL)isFront{
    [super setUIStatus:isFront];
    self.cardName.hidden = isFront ? YES : NO;
    self.cardBackgroundImage.hidden = isFront ? YES : NO;
    self.cardStar.hidden = isFront ? YES : NO;
    if (self.finished && !isFront) {
        self.finishIcon.hidden = NO;
    } else {
        self.finishIcon.hidden = YES;
    }
}

-(void)setValueWithModel:(CardModel *)card front:(BOOL)isFront{
    [super setValueWithModel:card front:isFront];
    
    self.cardName.text = card.cardName;
    self.cardName.attributedText = [QuanUtils setFontHeightForString:self.cardName.text lineSpacing:6 font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] textColor:[UIColor customisDarkGreyColor] alignment:NSTextAlignmentCenter];
    
    
    [self.cardBackgroundImage sd_setImageWithURL:[QuanUtils fullImagePath:card.cardPic] placeholderImage:[UIImage imageNamed:@"default_card"]];
    
    self.cardStar.image = [self switchStarToAppropriateImage:card.cardStar];

    if ([card.cardIsComplete isEqualToString:@"1"]) {
        self.finished = YES;
    } else {
        self.finished = NO;
    }
    
    [self setUIStatus:isFront];

}

-(void)showExerciseBtn:(BOOL)show{
    if (show) {
        self.exerciseBtn.hidden = NO;
    } else {
        self.exerciseBtn.hidden = YES;
    }
}

-(void)dealloc{
    self.cardWeb.scrollView.delegate = nil;
}

@end
