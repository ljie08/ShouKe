//
//  CardBackgroundImageCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/14.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardBackgroundImageCVCell.h"

@interface CardBackgroundImageCVCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starTop;

@property (assign, nonatomic) BOOL finished;


@end

@implementation CardBackgroundImageCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.basicCardView.layer.cornerRadius = 10;
    
}

-(void)updateConstraints{
    [super updateConstraints];
    
    self.starTop.constant = self.frame.size.height * 0.163;
    
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

-(void)setValueWithModel:(CardModel *)card andBackgroundPic:(NSString *)picPath front:(BOOL)isFront{
    
    [super setValueWithModel:card front:isFront];
    self.cardName.text = card.cardName;
    if (@available(iOS 8.2, *)) {
        self.cardName.attributedText = [QuanUtils setFontHeightForString:self.cardName.text lineSpacing:6 font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] textColor:[UIColor customisDarkGreyColor] alignment:NSTextAlignmentCenter];
    } else {
        // Fallback on earlier versions
    }
    
    [self.cardBackgroundImage sd_setImageWithURL:[QuanUtils fullImagePath:picPath] placeholderImage:[UIImage imageNamed:@"全背景图知识卡默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.cardBackgroundImage.layer.cornerRadius = 10;
        self.cardBackgroundImage.layer.masksToBounds = YES;
    }];

    
    self.cardStar.image = [self switchStarToAppropriateImage:card.cardStar];
    
    if ([card.cardIsComplete isEqualToString:@"1"]) {
        self.finished = YES;
    } else {
        self.finished = NO;
    }
    
    [self setUIStatus:isFront];
}

-(void)dealloc{
    self.cardWeb.scrollView.delegate = nil;
}

@end
