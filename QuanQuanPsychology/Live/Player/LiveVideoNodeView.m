//
//  LiveVideoNodeView.m
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/25.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "LiveVideoNodeView.h"

@interface LiveVideoNodeView()

@property (nonatomic, strong) UIButton *playBtn;/**<  */
@property (nonatomic, strong) UILabel *titleLab;/**<  */
@property (nonatomic, strong) UIView *bgView;/**< <#注释#> */
@property (nonatomic, strong) UIImageView *jianView;/**< <#注释#> */

@end

@implementation LiveVideoNodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _bgView = [[UIView alloc] init];
        [self addSubview:_bgView];
        
        _titleLab = [[UILabel alloc] init];
        [self.bgView addSubview:_titleLab];
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_playBtn];
        
        _jianView = [[UIImageView alloc] init];
        [self addSubview:_jianView];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
//    self.layer.masksToBounds = YES;
    
    self.bgView.frame = CGRectMake(0, 0, width, height-7);
    self.bgView.backgroundColor = [[UIColor colorwithHexString:@"#000000"] colorWithAlphaComponent:0.69];
    self.bgView.layer.cornerRadius = 15;
    self.bgView.layer.masksToBounds = YES;
    
    self.playBtn.frame = CGRectMake(width-11-30, 0, 30, 30);
    [self.playBtn setImage:[UIImage imageNamed:@"v_j_play"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"v_j_play"] forState:UIControlStateSelected];
    [self.playBtn setImage:[UIImage imageNamed:@"v_j_play"] forState:UIControlStateHighlighted];
    [self.playBtn addTarget:self action:@selector(playVideoNode) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLab.frame = CGRectMake(15, 0, width-15-12-11-30, height-7);
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    self.titleLab.textColor = [UIColor whiteColor];
    self.titleLab.font = [UIFont systemFontOfSize:14];
    
    self.jianView.frame = CGRectMake(CGRectGetMidX(self.bgView.frame)-5, height-8, 10, 7);
    self.jianView.image = [UIImage imageNamed:@"v_jian"];
}

- (void)setNodetitle:(NSString *)nodetitle {
    _nodetitle = nodetitle;
    self.titleLab.text = nodetitle;
//    [self.titleLab sizeToFit];
//    CGSize size = [self.titleLab.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];

//    [self updateViewsFrameWithWidth:size.width height:size.height];
}

- (void)updateViewsFrameWithWidth:(CGFloat)width height:(CGFloat)height {
    self.titleLab.frame = CGRectMake(15, 0, width, height);
    self.bgView.frame = CGRectMake(0, 0, width+15+12+30+11, height);
    self.jianView.frame = CGRectMake(CGRectGetMidX(self.bgView.frame), height-1, 10, 7);
}

- (void)playVideoNode {
    if (self.nodeBlock) {
        self.nodeBlock();
    }
}

@end
