//
//  CPBasicListCollectionView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CPBasicListCollectionView : UICollectionView

@property (strong, nonatomic) NSArray *cpLists;

@property (copy, nonatomic) void(^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp);

/* default is NO */
@property (assign, nonatomic) BOOL hasHeaderView;

@property (copy, nonatomic) void(^didClickMoreCPButton)(UIButton *button);


@end
