//
//  CardOverviewViewController.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardPackageDefine.h"

@interface CardOverviewViewController : QQBasicViewController

@property (strong, nonatomic) NSArray *allCards;

@property (assign, nonatomic) BOOL isCardPackage;

@end
