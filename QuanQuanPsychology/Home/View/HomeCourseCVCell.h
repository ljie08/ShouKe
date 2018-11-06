//
//  HomeCourseCVCell.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoCourseModel;

@interface HomeCourseCVCell : UICollectionViewCell

-(void)configureCellForIndex:(NSIndexPath *)indexPath withModel:(VideoCourseModel *)model;


@end
