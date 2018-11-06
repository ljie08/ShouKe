//
//  CPBaiscCVCell.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CPBaiscCVCell : UICollectionViewCell

-(void)configureCellForIndex:(NSIndexPath *)indexPath withModel:(CardPackageModel *)model;


@end
