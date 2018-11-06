//
//  MainGreenButton.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "MainGreenButton.h"

@implementation MainGreenButton

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [UIColor customisMainColor];
    
    self.layer.cornerRadius = 5;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:17];

}

@end
