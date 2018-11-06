//
//  KeyboardTextField.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/3/31.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "KeyboardTextField.h"

@interface KeyboardTextField ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *basicView;

@property (strong, nonatomic) UITextField *textField;

@property (assign, nonatomic) CGRect originalRect;

@end

@implementation KeyboardTextField

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initUI];
        [self initNotification];
    }
    
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGFloat basicH = 45;
    
    self.originalRect = CGRectMake(0, height - basicH, width, basicH);
    
    self.basicView = [[UIView alloc] initWithFrame:self.originalRect];
    self.basicView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.basicView];
    
    [self.basicView shadowOffset:CGSizeMake(0, 0.5) shadowColor:[UIColor colorwithHexString:@"#B5B5B5"] alpha:1 shadowRadius:6 shadowOpacity:1];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15, (self.basicView.frame.size.height - 30 ) / 2, self.basicView.frame.size.width - 15 * 2, 30)];
    self.textField.backgroundColor = [UIColor colorwithHexString:@"#F5F5F7"];
    self.textField.returnKeyType = UIReturnKeySend;
    self.textField.delegate = self;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.basicView addSubview:self.textField];
    
    [self.textField becomeFirstResponder];
    
}

#pragma mark - <UITextFieldDelegate>
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        
        self.textShouldSend(NO, @"");
        [textField resignFirstResponder];
        [self removeKeyboardTextField];
        return NO;
    } else {
       
        self.textShouldSend(YES, textField.text);
        [textField resignFirstResponder];
        [self removeKeyboardTextField];
        
        return YES;
    }
    
    
}

-(void)removeKeyboardTextField{
    [UIView animateWithDuration:0.05 animations:^{
        self.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Gesture
-(void)removeView:(UITapGestureRecognizer *)tap{
    [self removeKeyboardTextField];
}


#pragma mark - Notification
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

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

@end
