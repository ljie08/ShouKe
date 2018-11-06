//
//  CountDownTimer.m
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/16.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "CountDownTimer.h"

@interface CountDownTimer()

/* 倒计时 */
@property (strong, nonatomic) NSTimer *timer;

/* 总时间 */
@property (assign, nonatomic) NSInteger totalTime;

/* */
@property (assign, nonatomic) NSTimeInterval interval;

@end

@implementation CountDownTimer

-(instancetype)initWithTimeInterval:(NSTimeInterval)interval totalTime:(NSInteger)time{
    
    self = [super init];
    if (self) {
        self.timer = [NSTimer timerWithTimeInterval:interval target:self selector:@selector(refreshTime:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.totalTime = time;
        self.interval = interval;
    }
    
    return self;
}

-(void)refreshTime:(NSTimer *)time{
    
    self.totalTime = self.totalTime - (NSInteger)self.interval;
    
    if (self.totalTime < 0) {
        [self.timer invalidate];
        
        if ([self.delegate respondsToSelector:@selector(timeIsUp)]){
            [self.delegate timeIsUp];
        }
        
    } else {

        NSString *second = [NSString stringWithFormat:@"%lds后重新获取",(long)self.totalTime];
        
        if ([self.delegate respondsToSelector:@selector(timeLeft:)]){
            [self.delegate timeLeft:second];
        }

    }
}

-(void)invalidate{
    [self.timer invalidate];
    self.timer = nil;
}

@end
