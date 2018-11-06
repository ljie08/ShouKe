//
//  BannerPageView.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/19.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerPageView;
@protocol BannerPageViewDelegate <NSObject>

- (void)didClickImageAtIndex:(NSInteger)index scrollView:(BannerPageView *)scrollView;

@end

@interface BannerPageView : UIView

///* 轮播图图片 */
//@property (strong, nonatomic) NSArray *images;
//
//@property (copy, nonatomic) void(^didClickBanner)(UIButton *button);

@property (weak, nonatomic) id<BannerPageViewDelegate> delegate;
@property (assign, nonatomic) NSTimeInterval duringTime;            // 间隔时间，0表示不自动滚动

- (void)images:(NSArray *)images;
- (void)closeTimer;
- (void)openTimer;

@end
