//
//  LivePlayerPopupMenuView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/25.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "LivePlayerPopupMenuView.h"

@interface LivePlayerPopupMenuView()

@property (assign, nonatomic) BOOL hasCreat;

@end

@implementation LivePlayerPopupMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [[UIColor colorwithHexString:@"#000000"] colorWithAlphaComponent:0.86];
    }
    
    return self;
}

-(void)creatPopupWithTitles:(NSArray *)titles screen:(BOOL)fullScreen{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < titles.count; i++) {
        //        CGFloat height = self.frame.size.height / self.titles.count;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat height;
        CGFloat fontSize;
        if (fullScreen) {
//            height = 40;
            height = 53;
            fontSize = 14;
        } else {
//            height = 26;
            height = 35;
            fontSize = 10;
        }
        button.frame = CGRectMake(0, i * height, self.frame.size.width, height);
        button.tag = i;
        NSString *title = titles[i];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        [button addTarget:self action:@selector(buttonActions:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), self.frame.size.width, 1)];
        line.backgroundColor = [[UIColor colorwithHexString:@"#a9a9a9"] colorWithAlphaComponent:0.26];
        [self addSubview:line];
        
    }
}

-(void)buttonActions:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(popupMenu:onMenuClick:)]) {
        [self.delegate popupMenu:self onMenuClick:button];
    }
}

@end
