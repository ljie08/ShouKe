//
//  CPListCollectionReusableView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/18.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CardPackageModel;

@interface CPListCollectionReusableView : UICollectionReusableView

@property (copy, nonatomic) void(^lastCardButtonClick)(UIButton *button);

-(void)configureReusableViewWithModel:(CardPackageModel *)model;

@end
