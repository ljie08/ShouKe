//
//  CardPackageCVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/4.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardBasicCell.h"

@interface CardPackageCVCell : CardBasicCell

@property (weak, nonatomic) IBOutlet UIView *basicCardView;

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

@property (weak, nonatomic) IBOutlet UIImageView *cardStar;

@property (weak, nonatomic) IBOutlet UILabel *cardName;

@property (weak, nonatomic) IBOutlet UIImageView *finishIcon;



@end
