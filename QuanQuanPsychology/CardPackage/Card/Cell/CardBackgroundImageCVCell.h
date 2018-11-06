//
//  CardBackgroundImageCVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/14.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBasicCell.h"

@interface CardBackgroundImageCVCell : CardBasicCell

@property (weak, nonatomic) IBOutlet UIView *basicCardView;

@property (weak, nonatomic) IBOutlet UIImageView *cardBackgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *cardStar;

@property (weak, nonatomic) IBOutlet UILabel *cardName;

@property (weak, nonatomic) IBOutlet UIImageView *finishIcon;


-(void)setValueWithModel:(CardModel *)card andBackgroundPic:(NSString *)picPath front:(BOOL)isFront;

@end
