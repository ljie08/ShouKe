//
//  DefaultNetworkView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/12.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "DefaultNetworkView.h"

@interface DefaultNetworkView()

@end

@implementation DefaultNetworkView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self creatUI];
    }
    
    return self;
}

-(void)creatUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRefresh:)];
    [self addGestureRecognizer:tap];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.18 * ScreenHeight, ScreenWidth, ScreenWidth * 0.37)];
    image.image = [UIImage imageNamed:@"网络不稳定"];
    [self addSubview:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, image.frame.size.height + image.frame.origin.y + 16, ScreenWidth, 20)];
    label.text = @"网络不稳定，请点击页面刷新重试～";
    label.textColor = [UIColor colorwithHexString:@"#C9C9C9"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
}

-(void)tapToRefresh:(UITapGestureRecognizer *)tap{
    [self removeFromSuperview];
    self.refreshView();
}

@end
