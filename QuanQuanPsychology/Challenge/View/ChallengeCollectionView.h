//
//  ChallengeCollectionView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChallengeModel;

@interface ChallengeCollectionView : UICollectionView

@property (strong, nonatomic) NSArray *challenges;

@property (copy, nonatomic) void(^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath, ChallengeModel *challenge);

@end
