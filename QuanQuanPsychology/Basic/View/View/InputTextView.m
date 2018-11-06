//
//  InputTextView.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/7.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "InputTextView.h"

@interface InputTextView()<UITextViewDelegate>

@end

@implementation InputTextView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.content.delegate = self;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (self.content.text.length != 0) {
        self.contentPlaceholder.text = @"";
    } else {
        self.contentPlaceholder.text = @"从这里开始输入...";
        
    }
}

@end
