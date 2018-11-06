//
//  CardOverviewCVCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/8/22.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardOverviewCVCell.h"

@implementation CardOverviewCVCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initUI];
    
}

-(void)initUI{
    
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor colorwithHexString:@"#c8c8c8"].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    
    self.basicView.layer.cornerRadius = 5.0f;

}

-(void)setValueWithModel:(CardModel *)card{
    self.cardName.text = card.cardName;
}

@end
