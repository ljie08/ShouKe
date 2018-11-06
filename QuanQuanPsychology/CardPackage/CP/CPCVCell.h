//
//  CPCVCell.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CPCVCell : UICollectionViewCell

-(void)configureCellWithModel:(CardPackageModel *)model forIndexPath:(NSIndexPath *)indexPath;

@end
