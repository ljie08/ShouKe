//
//  CardViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/21.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardPackageModel;

@interface CardViewController : QQBasicViewController

@property (strong, nonatomic) CardPackageModel *cp;

/* 卡包上次看的卡片ID */
@property (copy, nonatomic) NSString *lastCardRecord;

@end
