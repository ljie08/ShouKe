//
//  PunchCardView.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PunchCardModel.h"

typedef void(^PunchCardBlock)(void);
typedef void(^PunchCardCloseBlock)(void);

@interface PunchCardView : UIView

@property (nonatomic, copy) PunchCardBlock cardBlock;/**< <#注释#> */
@property (nonatomic, copy) PunchCardCloseBlock closeBlock;/**< <#注释#> */

- (void)setViewsWithCard:(PunchCardModel *)card;/**< <#注释#> */
- (void)updateCardBtnEnabeld:(BOOL)enabled;

@end
