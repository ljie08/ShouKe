//
//  ActivationCodeView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/6.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "ActivationCodeView.h"

@interface ActivationCodeView()

@property (weak, nonatomic) IBOutlet UIView *basicView;

@property (weak, nonatomic) IBOutlet MainGreenButton *priceBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@end

@implementation ActivationCodeView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self updateUI];
}

-(void)updateUI{
    self.basicView.layer.cornerRadius = 10;
    self.priceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.backBtn.layer.cornerRadius = 5;
    self.backBtn.layer.borderWidth = 1;
    self.backBtn.layer.borderColor = [UIColor blackColor].CGColor;
}

#pragma mark - Setter
-(void)setWarningMsg:(NSString *)warningMsg{

}

#pragma mark - Button Actions
- (IBAction)pay:(MainGreenButton *)sender {
    self.buy(sender);
}

- (IBAction)back:(UIButton *)sender {
    self.cancel(sender);
    [self removeActivationView];
}

-(void)removeActivationView{
    [UIView animateWithDuration:0.5 animations:^{
        self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height, self.basicView.frame.size.width, self.basicView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [self.basicView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [self removeFromSuperview];
        }];
    }];
}

@end
