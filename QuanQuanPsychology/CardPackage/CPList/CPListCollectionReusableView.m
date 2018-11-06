//
//  CPListCollectionReusableView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/18.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CPListCollectionReusableView.h"

#import "CardPackageModel.h"

@interface CPListCollectionReusableView()

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet UIView *cardInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *decImage;

@property (weak, nonatomic) IBOutlet UILabel *cpTitle;

@property (weak, nonatomic) IBOutlet UIView *cardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cpImage;

@property (weak, nonatomic) IBOutlet UILabel *cpCourseName;

@property (weak, nonatomic) IBOutlet UILabel *lastLabel;

@property (weak, nonatomic) IBOutlet UIButton *studyBtn;

@end

@implementation CPListCollectionReusableView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.16 shadowRadius:3 shadowOpacity:1];
    
//    self.basicView.layer.cornerRadius = 9;
//    self.studyBtn.layer.borderWidth = 1;
//    self.studyBtn.layer.borderColor = [UIColor customisMainGreen].CGColor;
//    self.studyBtn.layer.cornerRadius = 4;

    [self.cardInfoView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.2 shadowRadius:6 shadowOpacity:1];
    [self.cardImageView shadowOffset:CGSizeMake(0, 2) shadowColor:[UIColor blackColor] alpha:0.2 shadowRadius:6 shadowOpacity:1];
    
    self.cardInfoView.layer.cornerRadius = 4;
    self.cardImageView.layer.cornerRadius = 4;

}

-(void)configureReusableViewWithModel:(CardPackageModel *)model{
    
    self.lastLabel.text = model.cpTitle;
    self.decImage.image = [UIImage imageNamed:@"card_deco_red"];

    [self.cpImage sd_setImageWithURL:[QuanUtils fullImagePath:model.cpTitlePic] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    self.cpCourseName.text = model.courseName;
}

- (IBAction)lastCard:(UIButton *)sender {
    self.lastCardButtonClick(sender);
}


@end
