//
//  NewVersionGuideView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/2/1.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "NewVersionGuideView.h"
#import "CustomizePageControl.h"

@interface NewVersionGuideView()<UIScrollViewDelegate>

@property (strong, nonatomic) CustomizePageControl *pageControl;

@property (strong, nonatomic) UIView *pageOne;

@property (strong, nonatomic) UIView *pageTwo;

@property (strong, nonatomic) UIView *pageThree;

@end

@implementation NewVersionGuideView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth * 3, 0);
    [self addSubview:self.scrollView];
    
    CGFloat y = ScreenHeight - ScreenHeight * 0.13 - 10;
    
    if (IS_IPHONE4S) {
        y += 10;
    }
    
    self.pageControl = [[CustomizePageControl alloc] initWithFrame:CGRectMake(0, y , ScreenWidth, 10)];
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor customisOrangeColor];
    [self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    
    [self creatGuideView];
}

-(void)creatGuideView{
    
    NSArray *images = @[[UIImage imageNamed:@"page_one"],
                        [UIImage imageNamed:@"page_two"],
                        [UIImage imageNamed:@"page_three"]];
    NSArray *titles = @[@"高频真题 这里应有尽有",@"视频课程 名师在线",@"主题卡包 快速掌握心理学"];
    NSArray *messageOnes = @[@"闯关模式",@"全面掌握心理知识",@"每天学点新知识"];
    NSArray *messageTwos = @[@"让学习心理更加有趣",@"助你扫清考试障碍",@"改变在悄然发生"];

    for (int i = 0; i < 3; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:view];
        
        CGFloat titleY = ScreenHeight * 0.174;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, titleY, ScreenWidth, 25)];
        title.textAlignment = NSTextAlignmentCenter;
        title.text = titles[i];
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:24];
        [view addSubview:title];
        
        
        CGFloat imageW = ScreenWidth * 0.53;
        CGFloat imageX = (ScreenWidth - imageW ) / 2;
        CGFloat imageY = titleY + 24 + ScreenHeight * 0.1;
        CGFloat imageH = imageW * 0.87;
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        image.image = images[i];
        [view addSubview:image];
        
        CGFloat messageOneX = ScreenWidth * 0.28;
        CGFloat messageOneW = ScreenWidth - messageOneX;
        CGFloat messageOneY = imageY + imageH + ScreenHeight * 0.1;
        CGFloat messageOneH = 20;

        UILabel *messageOne = [[UILabel alloc] initWithFrame:CGRectMake(messageOneX, messageOneY, messageOneW, messageOneH)];
        messageOne.textAlignment = NSTextAlignmentLeft;
        messageOne.text = messageOnes[i];
        messageOne.textColor = [UIColor blackColor];
        messageOne.font = [UIFont systemFontOfSize:18];
        [view addSubview:messageOne];
        
        CGFloat messageTwoX = messageOneX + 30;
        CGFloat messageTwoW = ScreenWidth - messageTwoX;
        CGFloat messageTwoY = messageOneY + messageOneH + 10;

        UILabel *messageTwo = [[UILabel alloc] initWithFrame:CGRectMake(messageTwoX, messageTwoY, messageTwoW, messageOneH)];
        messageTwo.textAlignment = NSTextAlignmentLeft;
        messageTwo.text = messageTwos[i];
        messageTwo.textColor = [UIColor blackColor];
        messageTwo.font = [UIFont systemFontOfSize:18];
        [view addSubview:messageTwo];
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / ScreenWidth;
    self.pageControl.currentPage = page;
    
    if (scrollView.contentOffset.x > (ScreenWidth * 2 + 20) ) {
        [self removerGuide];
    }
    
}

-(void)pageChanged{
    NSInteger page = self.pageControl.currentPage;
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * page, 0)];
}

-(void)skipGuide:(UIButton *)button{
    
    [self removerGuide];

}

-(void)enterApp:(UIButton *)button{
    [self removerGuide];
}

-(void)removerGuide{
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = CGRectMake(-ScreenWidth, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
        
        if ([self.delegate respondsToSelector:@selector(removeVersionGuide)]) {
            [self.delegate removeVersionGuide];
        }
        
    }];
}

@end
