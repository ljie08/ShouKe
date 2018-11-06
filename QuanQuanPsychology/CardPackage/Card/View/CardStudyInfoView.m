//
//  CardStudyInfoView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/23.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardStudyInfoView.h"



@implementation CardStudyInfoView

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
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.number = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height * 0.48)];
    self.number.textColor = [UIColor colorwithHexString:@"#20C997"];
    self.number.font = [UIFont systemFontOfSize:30 weight:UIFontWeightMedium];
    self.number.adjustsFontSizeToFitWidth = YES;
    self.number.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.number];
    
    self.item = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 25, width, 25)];
    self.item.textColor = [UIColor colorwithHexString:@"#666666"];
    self.item.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.item.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.item];
}


-(void)updateNumber:(NSString *)number unit:(NSString *)unit item:(NSString *)item{
    self.number.text = number;
    self.item.text = item;
    
    NSString *full = [number stringByAppendingString:[NSString stringWithFormat:@" %@",unit]];
    self.number.attributedText = [QuanUtils formatText:full withAttributedText:unit color:[UIColor colorwithHexString:@"#BFBFBF"] font:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
}


@end
