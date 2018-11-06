//
//  HomeCourseCollectionView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoCourseModel;

@interface HomeCourseCollectionView : UICollectionView

@property (strong, nonatomic) NSArray *courseLists;

@property (copy, nonatomic) void(^didSelectItemAtIndexPath)(UICollectionView *collectionView, NSIndexPath *indexPath, VideoCourseModel *course);


@end
