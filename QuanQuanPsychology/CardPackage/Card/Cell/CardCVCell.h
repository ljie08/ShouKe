//
//  CardCVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBasicCell.h"

@interface CardCVCell : CardBasicCell

@property (weak, nonatomic) IBOutlet UIView *basicCardView;

@property (weak, nonatomic) IBOutlet UIImageView *cardBackgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *cardStar;

@property (weak, nonatomic) IBOutlet UILabel *cardName;

@property (weak, nonatomic) IBOutlet UIImageView *finishIcon;

-(void)showExerciseBtn:(BOOL)show;

@end
