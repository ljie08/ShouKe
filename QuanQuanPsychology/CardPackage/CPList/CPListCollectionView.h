//
//  CPListCollectionView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CPListCollectionView : UICollectionView

@property (strong, nonatomic) NSArray *cpLists;

@property (copy, nonatomic) void(^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath, CardPackageModel *cp);

@property (copy, nonatomic) void(^lastCardButtonClickForRecordCp)(UIButton *button);

@property (strong, nonatomic) CardPackageModel *recordCP;


@end
