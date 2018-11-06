//
//  CardPackageCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/4.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardPackageCVCell.h"

@interface CardPackageCVCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;

@property (assign, nonatomic) BOOL finished;


@end

@implementation CardPackageCVCell

-(void)updateConstraints{
    [super updateConstraints];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    self.imageH.constant = height * 0.479;
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.basicCardView.layer.cornerRadius = 10;

}

#pragma mark - override
-(void)setUIStatus:(BOOL)isFront{
    [super setUIStatus:isFront];
    self.cardName.hidden = isFront ? YES : NO;
    self.cardImage.hidden = isFront ? YES : NO;
    self.cardStar.hidden = isFront ? YES : NO;
    if (self.finished && !isFront) {
        self.finishIcon.hidden = NO;
    } else {
        self.finishIcon.hidden = YES;
    }}

-(void)setValueWithModel:(CardModel *)card front:(BOOL)isFront{
    [super setValueWithModel:card front:isFront];
    
    self.cardName.text = card.cardName;
    if (@available(iOS 8.2, *)) {
        self.cardName.attributedText = [QuanUtils setFontHeightForString:self.cardName.text lineSpacing:6 font:[UIFont systemFontOfSize:24 weight:UIFontWeightMedium] textColor:[UIColor customisDarkGreyColor] alignment:NSTextAlignmentLeft];
    } else {
        // Fallback on earlier versions
    }
    
    self.cardImage.layer.masksToBounds = YES;

    [self.cardImage sd_setImageWithURL:[QuanUtils fullImagePath:card.cardPic] placeholderImage:[UIImage imageNamed:@"精编知识卡默认图"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.cardImage.layer.masksToBounds = YES;
        
        self.cardImage.layer.mask = [QuanUtils addRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:CGSizeMake(10.0, 10.0) viewRect:self.cardImage.bounds];
        
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
