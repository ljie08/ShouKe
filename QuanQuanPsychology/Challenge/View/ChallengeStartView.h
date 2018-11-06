//
//  ChallengeStartView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/26.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChallengeModel;

@interface ChallengeStartView : UIView

/*  */
@property (copy, nonatomic) void(^startToPlay)(UIButton *button);

-(void)updateUIWithModel:(ChallengeModel *)challenge;

@end
