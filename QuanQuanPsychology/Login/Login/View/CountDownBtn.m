//
//  CountDownBtn.m
//  MoxiLjieApp
//
//  Created by Libra on 2018/8/20.
//  Copyright © 2018年 AppleFish. All rights reserved.
//

#import "CountDownBtn.h"


@interface CountDownBtn () {
    NSInteger _num;//倒计时时间
}

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CountDownBtn

- (instancetype)init {
    if (self = [super init]) {
//        [self initDefault];
    }
    return self;
}

/**
 初始化默认配置
 */
- (void)initDefault {
    //背景颜色
    self.bgColor = self.bgColor ? self.bgColor : [UIColor whiteColor];
    self.backgroundColor = self.bgColor;
    
    //不可点击时的背景颜色
    self.disabledBgColor = self.disabledBgColor ? self.disabledBgColor : [UIColor whiteColor];
    
    //字体大小
    self.fontSize = self.fontSize ? self.fontSize : 14;
    self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    
    [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _num = self.countNum;
}

#pragma mark - setter
- (void)setCountNum:(NSInteger)countNum {
    if (_countNum != countNum) {
        _countNum = countNum;
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    if (_bgColor != bgColor) {
        _bgColor = bgColor;
    }
}

- (void)setDisabledBgColor:(UIColor *)disabledBgColor {
    if (_disabledBgColor != disabledBgColor) {
        _disabledBgColor = disabledBgColor;
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    if (_fontSize != fontSize) {
        _fontSize = fontSize;
    }
//    [self initDefault];
}

- (void)setBtnBlock:(ButtonClickedBlock)btnBlock {
    if (btnBlock != _btnBlock) {
        _btnBlock = btnBlock;
    }
}

- (void)setCountdowningBlock:(CountDowningBlock)countdowningBlock {
    if (countdowningBlock != _countdowningBlock) {
        _countdowningBlock = countdowningBlock;
    }
}

- (void)setCompletionBlock:(CountDownCompletionBlock)completionBlock {
    if (completionBlock != _completionBlock) {
        _completionBlock = completionBlock;
    }
}

#pragma mark - 方法
/**
 按钮点击

 @param button <#button description#>
 */
- (void)btnClicked:(CountDownBtn *)button {
    button.enabled = NO;
    self.btnBlock();
}

/**
 开始倒计时
 */
- (void)beginCountDown {
    [self setTimer];
    [self setBtn];
}

/**
 定时器方法

 @param sender <#sender description#>
 */
- (void)timechange:(id)sender {
    _num--;
//    NSLog(@" num ----- %ld", _num);
    self.countdowningBlock(_num);
    //title
    
    if (_num == 0) {
        [self endCountDown];
        self.completionBlock();
    }
    
}

/**
 倒计时结束
 */
- (void)endCountDown {
    [self resetBtn];
    [self resetTimer];
}

#pragma mark - 初始设置和重置
/**
 初始化按钮设置
 */
- (void)setBtn {
    self.enabled = NO;
    self.backgroundColor = self.disabledBgColor;
    //title
//    [self setTitle:[NSString stringWithFormat:@"59s后重试"] forState:UIControlStateNormal];
}


/**
 初始化定时器
 */
- (void)setTimer {
    self.timer = self.timer ? : [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechange:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

/**
 重置按钮
 */
- (void)resetBtn {
    self.enabled = YES;
    self.backgroundColor = self.bgColor;
    //title
}

/**
 重置定时器
 */
- (void)resetTimer {
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
    _num = self.countNum;
}

- (void)dealloc {
    
    NSLog(@"dealoc ..... ");
}

@end
