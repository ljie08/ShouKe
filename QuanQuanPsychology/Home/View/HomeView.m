//
//  HomeView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/15.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "HomeView.h"

@implementation HomeView

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

-(void)layoutSubviews{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
    self.item.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
}

-(void)initUI{
    
    self.icon = [[UIImageView alloc] init];
    [self addSubview:self.icon];
    
    self.item = [[UILabel alloc] init];
    self.item.textColor = [UIColor customisDarkGreyColor];
    self.item.textAlignment = NSTextAlignmentCenter;
    if (IS_IPHONE4S || IS_IPHONE5) {
        self.item.font = [UIFont systemFontOfSize:11];
    } else {
        self.item.font = [UIFont systemFontOfSize:12];
    }
    self.item.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.item];
}

-(void)updateIcon:(UIImage *)image item:(NSString *)item{
    self.icon.image = image;
    self.item.text = item;
}
@end
