//
//  UserView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/15.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "UserView.h"

@implementation UserView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}

-(void)initUI{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(( width - 24 ) /2, 0, 24, 24)];
    [self addSubview:self.icon];
    
    self.item = [[UILabel alloc] initWithFrame:CGRectMake(0, height - 20, width, 20)];
    self.item.textColor = [UIColor customisDarkGreyColor];
    self.item.textAlignment = NSTextAlignmentCenter;
    self.item.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self addSubview:self.item];
}

-(void)initWithIcon:(UIImage *)image item:(NSString *)item{
    self.icon.image = image;
    self.item.text = item;
}

@end
