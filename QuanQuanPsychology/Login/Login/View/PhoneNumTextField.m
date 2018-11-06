//
//  PhoneNumTextField.m
//  ShouKe
//
//  Created by Libra on 2018/10/11.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import "PhoneNumTextField.h"

@implementation PhoneNumTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.length = 0;
    [self addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
}

- (instancetype)init {
    if (self = [super init]) {
        self.length = 0;
        [self addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.length = 0;
        [self addTarget:self action:@selector(textFieldDidEditing:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}

//188 8888 8888
- (void)textFieldDidEditing:(UITextField *)textField {
    if (textField == self) {
        if (textField.text.length > self.length) {
            if (textField.text.length == 4 || textField.text.length == 9 ) {
                //输入
                NSMutableString * str = [[NSMutableString alloc ] initWithString:textField.text];
                [str insertString:@" " atIndex:(textField.text.length-1)];
                textField.text = str;
                
            } else if (textField.text.length >= 13 ) {//输入完成
                textField.text = [textField.text substringToIndex:13];
                [textField resignFirstResponder];
            }
            self.length = textField.text.length;
            
        } else if (textField.text.length < self.length){//删除
            if (textField.text.length == 4 || textField.text.length == 9) {
                textField.text = [NSString stringWithFormat:@"%@",textField.text];
                textField.text = [textField.text substringToIndex:(textField.text.length-1)];
            }
            self.length = textField.text.length;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
