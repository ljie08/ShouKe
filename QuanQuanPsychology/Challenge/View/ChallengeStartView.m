//
//  ChallengeStartView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/26.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "ChallengeStartView.h"
#import "ChallengeModel.h"

@interface ChallengeStartView()

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *level;

@property (weak, nonatomic) IBOutlet UIView *line;

@property (weak, nonatomic) IBOutlet UILabel *intro;

@property (weak, nonatomic) IBOutlet UIView *dynamicView;

@property (weak, nonatomic) IBOutlet MainGreenButton *startBtn;

@property (weak, nonatomic) IBOutlet UIImageView *tipIcon;

@property (weak, nonatomic) IBOutlet UILabel *tip;


@end

@implementation ChallengeStartView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.basicView.layer.cornerRadius = 10;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)updateUIWithModel:(ChallengeModel *)challenge{
    
    self.level.text = [NSString stringWithFormat:@"第%@关",challenge.currentLevel];
    
    if ([NSString stringIsNull:challenge.accuracy]) {
        
        self.intro.text = @"本关难度";
        
        NSInteger difficulty = [challenge.difficulty integerValue];

        CGFloat size = 15;
        CGFloat y = (self.dynamicView.frame.size.height - size) / 2;
        CGFloat gap = 10;
        CGFloat x = (ScreenWidth * 0.77 - size - (size + gap) * (difficulty - 1)) / 2;

        for (int i = 0; i < difficulty; i++) {
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(x +  (size + gap) * i , y, size, size)];
            image.image = [UIImage imageNamed:@"challenge_difficulty"];
            [self.dynamicView addSubview:image];
        }
        
        [self.startBtn setTitle:@"开始闯关" forState:UIControlStateNormal];
        
    } else {
        
        self.intro.text = @"当前正确率";
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.dynamicView.frame.size.height - 40) / 2, ScreenWidth * 0.77, 40)];
        label.text = [NSString stringWithFormat:@"%.0f%%",[challenge.accuracy doubleValue] * 100];
        
        if ([challenge.accuracy doubleValue] < [challenge.passingRate doubleValue]) {
            label.textColor = [UIColor colorwithHexString:@"#C9C9C9"];
        } else {
            label.textColor = [UIColor customisMainGreen];
        }
        
        label.font = [UIFont systemFontOfSize:24];
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.dynamicView addSubview:label];
        
        [self.startBtn setTitle:@"再来一次" forState:UIControlStateNormal];

    }
    
    self.tip.text = [NSString stringWithFormat:@"正确率达到%.0f%%才能开启下一关",[challenge.passingRate doubleValue] * 100];
    
}

#pragma mark - Button Action
- (IBAction)start:(MainGreenButton *)sender {
    self.startToPlay(sender);
    [self removeFromSuperview];
}

- (IBAction)close:(UIButton *)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
        
    }];
}


@end
