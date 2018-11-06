//
//  CountDownTimer.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/16.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CountDownDelegate<NSObject>

-(void)timeLeft:(NSString *)seconds;

-(void)timeIsUp;

@end

@interface CountDownTimer : NSObject

@property (weak, nonatomic) id<CountDownDelegate> delegate;

-(instancetype)initWithTimeInterval:(NSTimeInterval)interval totalTime:(NSInteger)time;
-(void)invalidate;

@end
