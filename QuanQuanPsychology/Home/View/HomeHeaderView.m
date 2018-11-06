//
//  HomeHeaderView.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/8/8.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "HomeHeaderView.h"

static NSInteger const headerHeight = 40;

@implementation HomeHeaderView

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
    self.backgroundColor = [UIColor clearColor];
    
    UIView *color = [[UIView alloc] initWithFrame:CGRectMake(0, 10 , ScreenWidth, headerHeight-10)];
    color.backgroundColor = [UIColor whiteColor];
    [self addSubview:color];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, headerHeight-10-14, 15, 14)];
    img.image = [UIImage imageNamed:@"zuanshi"];
    [color addSubview:img];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, headerHeight-10-14, 60, 14)];
    label.text = @"精选好课";
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor customisDarkGreyColor];
//    if (@available(iOS 8.2, *)) {
//        label.font = [UIFont systemFontOfSize:13 weight:UIFontWeightBold];
//    } else {
//    }
    label.font = [UIFont systemFontOfSize:13];
    [color addSubview:label];
    
//    UIView *left = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame)-45, headerHeight/2-0.5, 35, 1)];
//    left.backgroundColor = [UIColor colorwithHexString:@"#979797"];
//    [self addSubview:left];
//
//    UIView *right = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+10, headerHeight/2-0.5, 35, 1)];
//    right.backgroundColor = [UIColor colorwithHexString:@"#979797"];
//    [self addSubview:right];
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-115, 0, 100, headerHeight)];
    [more setTitle:@"更多" forState:UIControlStateNormal];
    [more setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
    more.titleLabel.font = [UIFont systemFontOfSize:10];
    more.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    more.titleLabel.textAlignment = NSTextAlignmentRight;
    more.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 15);
    [more setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
    more.imageEdgeInsets = UIEdgeInsetsMake(10, 90, 0, 0);
    [more addTarget:self action:@selector(moreCourse:) forControlEvents:UIControlEventTouchUpInside];
    [color addSubview:more];
}

-(void)moreCourse:(UIButton *)button{
    self.didClickMoreCourseButton(button);
}

@end
