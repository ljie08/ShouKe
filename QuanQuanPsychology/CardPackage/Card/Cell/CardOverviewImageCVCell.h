//
//  CardOverviewImageCVCell.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardOverviewImageCVCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet UILabel *cardName;

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;

-(void)setValueWithModel:(CardModel *)card;

@end
