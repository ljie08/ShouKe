//
//  KeyboardTextView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/8.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "KeyboardTextView.h"

@interface KeyboardTextView()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGRect originalRect;

@end

@implementation KeyboardTextView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
        [self initNotification];
    }
    
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat basicH = 148;

    self.originalRect = CGRectMake(0, height - basicH, width, basicH);
    
    self.basicView = [[UIView alloc] initWithFrame:self.originalRect];
    self.basicView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.basicView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 8, width - 15 * 2, basicH * 0.42)];
    self.textView.textColor = [UIColor customisDarkGreyColor];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.delegate = self;
    [self.textView becomeFirstResponder];
    self.textView.tag = 201;
    [self.basicView addSubview:self.textView];
    
    CGFloat wordY = self.textView.frame.origin.y + self.textView.frame.size.height + 6;
    
    self.wordCount = [[UILabel alloc] initWithFrame:CGRectMake(0, wordY, width - 15, 20)];
    self.wordCount.textAlignment = NSTextAlignmentRight;
    self.wordCount.textColor = [UIColor colorwithHexString:@"#C9C9C9"];
    self.wordCount.font = [UIFont systemFontOfSize:14];
    [self.basicView addSubview:self.wordCount];
    
    CGFloat lineY = self.wordCount.frame.origin.y + self.wordCount.frame.size.height + 8;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, lineY, width - 15 * 2, 1)];
    line.backgroundColor = [UIColor colorwithHexString:@"#E5E5E5"];
    [self.basicView addSubview:line];
    
    CGFloat btnH = basicH - lineY - 1;
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, lineY + 1, width / 2, btnH)];
    self.cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.basicView addSubview:self.cancelBtn];
    
    self.doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(width / 2, lineY + 1, width / 2, btnH)];
    self.doneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.doneBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    [self.doneBtn setTitle:@"提交" forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:[UIColor customisDarkGreyColor] forState:UIControlStateNormal];
    self.doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.basicView addSubview:self.doneBtn];
    
}

-(void)setMaxWordCount:(NSInteger)maxWordCount{
    _maxWordCount = maxWordCount;
    self.wordCount.text = [NSString stringWithFormat:@"(0/%ld)字",(long)maxWordCount];
}

-(void)initNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWasShown:(NSNotification*)aNotification{
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [aValue CGRectValue].size.height;
    
    //使视图上移
    [UIView animateWithDuration:0.05 animations:^{
        CGRect viewFrame = self.originalRect;
        viewFrame.origin.y = viewFrame.origin.y - height;
        self.basicView.frame = viewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Gesture
-(void)removeView:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.05 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - Button Actions
-(void)cancel:(UIButton *)button{
    
    [UIView animateWithDuration:0.05 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

#pragma mark - <UITextViewDelegate>
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > self.maxWordCount) {
        self.textView.text = [textView.text substringToIndex:self.maxWordCount];
    }
    
    self.wordCount.text = [NSString stringWithFormat:@"(%ld/%ld)字",self.textView.text.length,self.maxWordCount];
    
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    UIView *view = gestureRecognizer.view;
    
    if( view == self.basicView) {
        return NO;
    }
    
    return  YES;
    
}

@end
