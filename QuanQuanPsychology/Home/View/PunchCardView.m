//
//  PunchCardView.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "PunchCardView.h"

@interface PunchCardView()

@property (weak, nonatomic) IBOutlet UILabel *dayLab;
@property (weak, nonatomic) IBOutlet UIButton *cardBtn;

@end

@implementation PunchCardView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setViewsWithCard:(PunchCardModel *)card {
    self.dayLab.text = [NSString stringWithFormat:@"%ld", card.signs];
    self.cardBtn.enabled = card.mySignFlag;
    
    if (self.cardBtn.enabled) {
        self.cardBtn.backgroundColor = [UIColor customisOrangeColor];
    } else {
        self.cardBtn.backgroundColor = [UIColor colorwithHexString:@"#dbdbdb"];
    }
}

- (void)updateCardBtnEnabeld:(BOOL)enabled {
    self.dayLab.text = [NSString stringWithFormat:@"%ld", [self.dayLab.text integerValue]+1];
    self.cardBtn.enabled = enabled;
    if (self.cardBtn.enabled) {
        self.cardBtn.backgroundColor = [UIColor customisOrangeColor];
    } else {
        self.cardBtn.backgroundColor = [UIColor colorwithHexString:@"#dbdbdb"];
    }
}

- (void)setDay:(NSString *)day {
    self.dayLab.text = day;
}

- (IBAction)punchCard:(id)sender {
    if (self.cardBlock) {
        self.cardBlock();
    }
}

- (IBAction)close:(id)sender {
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end
