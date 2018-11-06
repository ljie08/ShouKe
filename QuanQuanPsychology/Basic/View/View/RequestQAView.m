//
//  RequestQAView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/2.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "RequestQAView.h"

@interface RequestQAView()<UITextViewDelegate>

@end

@implementation RequestQAView

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self updateUI];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.basicView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    shape.frame = self.basicView.bounds;
    [shape setPath:rounded.CGPath];
    self.basicView.layer.mask = shape;
}

-(void)updateUI{
    
    self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height, self.basicView.frame.size.width, self.basicView.frame.size.height);
    
    self.dismissBtn.frame = CGRectMake(self.dismissBtn.frame.origin.x, self.frame.size.height, self.dismissBtn.frame.size.width, self.dismissBtn.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height * 0.184, self.basicView.frame.size.width, self.basicView.frame.size.height);
        
        self.dismissBtn.frame = CGRectMake(self.dismissBtn.frame.origin.x, self.basicView.frame.origin.y - 15 - 26, self.dismissBtn.frame.size.width, self.dismissBtn.frame.size.height);
        
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard:)];
    [self addGestureRecognizer:tap];
    
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
//
//    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
//    toolBar.items = @[space,done];
    
//    self.qContent.inputAccessoryView = toolBar;
    
    
    self.qContent.delegate = self;
    self.qContent.tag = 202;
    
    self.photoOne.index = 0;
    self.photoOne.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.photoTwo.index = 1;
    self.photoTwo.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.photoTwo.hidden = YES;

    self.photoThree.index = 2;
    self.photoThree.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.photoThree.hidden = YES;

}

#pragma mark - Gesture
-(void)removeKeyboard:(UITapGestureRecognizer *)tap{
    
    [self.qContent resignFirstResponder];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height, self.basicView.frame.size.width, self.basicView.frame.size.height);
//        self.dismissBtn.frame = CGRectMake(self.dismissBtn.frame.origin.x, self.frame.size.height, self.dismissBtn.frame.size.width, self.dismissBtn.frame.size.height);
//    } completion:^(BOOL finished) {
//        [self.basicView removeFromSuperview];
//        [UIView animateWithDuration:0.5 animations:^{
//            [self removeFromSuperview];
//        }];
//    }];
}

#pragma mark - <UITextViewDelegate>
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.qPlaceholder.text = @"";
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView == self.qContent && textView.text.length > 60) {
        self.qContent.text = [textView.text substringToIndex:60];
    }
    
    self.wordCount.text = [NSString stringWithFormat:@"(%ld/60)字",(unsigned long)self.qContent.text.length];
    
}

- (IBAction)cancel:(MainGreenButton *)sender {
    if ([_delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
        [_delegate cancelButtonClicked:sender];
    }
    
}

- (IBAction)requestQA:(MainGreenButton *)sender {
    if ([_delegate respondsToSelector:@selector(requestButtonClicked:)]) {
        [_delegate requestButtonClicked:sender];
    }
}

- (IBAction)dismiss:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(dismissButtonClicked:)]) {
        [_delegate dismissButtonClicked:sender];
    }
}

-(void)hideKeyboard{
    
    if ([self.qContent isFirstResponder]) {
        [self.qContent resignFirstResponder];
    }
}

@end
