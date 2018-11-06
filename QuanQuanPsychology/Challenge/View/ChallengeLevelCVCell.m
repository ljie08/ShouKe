//
//  ChallengeLevelCVCell.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/24.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ChallengeLevelCVCell.h"
#import "ChallengeModel.h"

@interface ChallengeLevelCVCell()

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet UILabel *level;

@property (weak, nonatomic) IBOutlet UIImageView *lock;

@property (weak, nonatomic) IBOutlet UIImageView *lockStar;

@end

@implementation ChallengeLevelCVCell

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self shadowOffset:CGSizeMake(0, 0.5) shadowColor:[UIColor blackColor] alpha:0.22 shadowRadius:3 shadowOpacity:1];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = NO;
    
//    self.level.font = [UIFont fontWithName:@"DFPHaiBaoW12" size:36];
    self.level.adjustsFontSizeToFitWidth = YES;
    self.level.textColor = [UIColor colorwithHexString:@"#ff9a11"];
    
    self.basicView.layer.cornerRadius = 5;
    self.basicView.clipsToBounds = YES;
}

-(void)configureCellForIndexPath:(NSIndexPath *)indexPath
                withCurrentLevel:(NSInteger)currentLevel{
    if ((indexPath.row + 1) <= currentLevel) {
        self.lock.hidden = YES;
        self.level.hidden = NO;
        self.level.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
//        self.basicView.layer.borderColor = [UIColor customisOrangeColor].CGColor;
//        self.basicView.layer.borderWidth = 3.5;
//        self.basicView.layer.masksToBounds = YES;
    } else {
        self.level.hidden = YES;
        self.lock.hidden = NO;
//        self.contentView.layer.borderColor = [UIColor customisOrangeColor].CGColor;
        self.contentView.layer.borderWidth = 0;
    }
    
    if ((indexPath.row + 1 ) % 6 == 0) {
//        self.lockStar.hidden = NO;
        self.lock.image = [UIImage imageNamed:@"c_lock_star"];
    } else {
//        self.lockStar.hidden = YES;
        self.lock.image = [UIImage imageNamed:@"c_lock"];
    }
}

-(void)configureCellWithModel:(ChallengeModel *)challenge forIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row <= [challenge.passedLevel integerValue]) {
        self.lock.hidden = YES;
        self.level.hidden = NO;
        self.level.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        if (indexPath.row == [challenge.passedLevel integerValue]) {
            self.basicView.layer.borderColor = [UIColor colorwithHexString:@"#ff9a11"].CGColor;
            self.basicView.layer.borderWidth = 3.5;
            self.basicView.layer.masksToBounds = YES;
            self.basicView.backgroundColor = [UIColor whiteColor];
            self.level.textColor = [UIColor colorwithHexString:@"ff9a11"];
        } else {
            self.basicView.layer.borderWidth = 0;
            self.basicView.layer.borderColor = [UIColor clearColor].CGColor;
            self.basicView.layer.masksToBounds = NO;
            self.basicView.backgroundColor = [UIColor colorwithHexString:@"ff9a11"];
            self.level.textColor = [UIColor whiteColor];
        }
    } else {
        self.basicView.backgroundColor = [UIColor whiteColor];
        self.basicView.layer.borderWidth = 0;
        self.basicView.layer.borderColor = [UIColor clearColor].CGColor;
        self.basicView.layer.masksToBounds = NO;
        self.level.hidden = YES;
        self.lock.hidden = NO;
//        self.contentView.layer.borderColor = [UIColor customisOrangeColor].CGColor;
        self.contentView.layer.borderWidth = 0;
    }
    
    if ((indexPath.row + 1 ) % 6 == 0) {
//        self.lockStar.hidden = NO;
        self.lock.image = [UIImage imageNamed:@"c_lock_star"];
    } else {
//        self.lockStar.hidden = YES;
        self.lock.image = [UIImage imageNamed:@"c_lock"];
    }
    
}

@end
