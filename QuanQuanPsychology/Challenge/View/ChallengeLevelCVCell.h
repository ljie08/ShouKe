//
//  ChallengeLevelCVCell.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/24.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChallengeModel;

@interface ChallengeLevelCVCell : UICollectionViewCell

-(void)configureCellWithModel:(ChallengeModel *)challenge
                 forIndexPath:(NSIndexPath *)indexPath;

@end
