//
//  AnswerSheetCell.m
//  QuanQuan
//
//  Created by Jocelyn on 16/11/2.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "AnswerSheetCell.h"

@implementation AnswerSheetCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLabel];
    }
    
    return self;
}

-(void)addLabel{
    _number = [[UILabel alloc] initWithFrame:self.bounds];
    _number.textAlignment = NSTextAlignmentCenter;
    _number.font = [UIFont systemFontOfSize:17];
    _number.layer.cornerRadius = _number.frame.size.height / 2;
    _number.layer.masksToBounds = YES;
    _number.tag = 100;
    [self.contentView addSubview:_number];
}

-(void)checkID{
    [[self viewWithTag:100] removeFromSuperview];
    [self addLabel];
}

@end
