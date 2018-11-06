//
//  CodeTextView.m
//  ShouKe
//
//  Created by Libra on 2018/10/15.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import "CodeTextView.h"
#import "IQUIView+IQKeyboardToolbar.h"

//#define OrangeColor [UIColor colorwithHexString:@"#FFA900"]
#define NormalColor [UIColor colorwithHexString:@"#D2D2D2"]

@interface CodeTextView()<UITextViewDelegate, UITextFieldDelegate>

//@property (nonatomic, strong) UITextField *textField;/**< <#注释#> */
@property (nonatomic, strong) UITextView *textView;/**< 输入框 */
@property (nonatomic, strong) NSMutableArray *labelArr;/**< 验证码label */
@property (nonatomic, strong) NSMutableArray *lineArr;/**< 光标 */

@end

@implementation CodeTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initDefaultData];
}

- (void)initDefaultData {
    self.codeLength = 6;
    self.textView.tag = 1111;
}

- (void)layoutSubviews {
//    self.textField = [[UITextField alloc] initWithFrame:self.bounds];
//    self.textField.keyboardType = UIKeyboardTypeNumberPad;
//    self.textField.returnKeyType = UIReturnKeyGo;
//    self.textField.delegate = self;
//    self.textField.textColor = [UIColor clearColor];
//    self.textField.tintColor = [UIColor clearColor];
//    [self addSubview:self.textField];
    
    self.textView = [[UITextView alloc] initWithFrame:self.bounds];
    self.textView.keyboardType = UIKeyboardTypeNumberPad;
    self.textView.returnKeyType = UIReturnKeyGo;
    self.textView.delegate = self;
    self.textView.tag = 20181023;
    self.textView.tintColor = [UIColor clearColor];
    self.textView.textColor = [UIColor clearColor];
//    [self.textView addDoneOnKeyboardWithTarget:self action:@selector(textviewDoneAction)];
    [self addSubview:self.textView];
    
    for (int i = 0; i < self.codeLength; i++) {
        UILabel *codeLab = [[UILabel alloc] initWithFrame:CGRectMake((33+22)*i, 0, 33, 42)];
        codeLab.backgroundColor = [UIColor clearColor];
        codeLab.layer.borderWidth = 1.5;
        codeLab.layer.cornerRadius = 5;
        codeLab.layer.masksToBounds = YES;
        codeLab.textAlignment = NSTextAlignmentCenter;
        codeLab.font = FONT(20);
        codeLab.tag = 3000+i;
        [self addSubview:codeLab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(codeLab.frame)-0.5, 11, 1, 20)];
        line.backgroundColor = [UIColor customisMainColor];
        line.userInteractionEnabled = YES;
        [line.layer addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
        [self addSubview:line];
        line.tag = 2000+i;
        
//        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetMidX(codeLab.frame)-0.5, 11, 1, 20)];
//        CAShapeLayer *line = [CAShapeLayer layer];
//        line.path = path.CGPath;
//        line.fillColor = [UIColor greenColor].CGColor;
//        [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
//        [codeLab.layer addSublayer:line];

//        if (i == 0) {
//            codeLab.layer.borderColor = OrangeColor.CGColor;//选中边框颜色
//            line.hidden = NO;
//        } else {
//        }
        codeLab.layer.borderColor = NormalColor.CGColor;//未选中边框颜色
        line.hidden = YES;//默认隐藏
        [self.lineArr addObject:line];
        [self.labelArr addObject:codeLab];
    }
}

//输入完成自动登录
- (void)finishInputWithCode:(NSString *)code {
    NSLog(@"909090");
    if (self.codeBlock) {
        self.codeBlock(code);
    }
}

#pragma mark - delegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

//开始编辑的时候显示光标和边框选中颜色
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self changeLabelBorderColorWithSelected:YES lineHidden:NO index:0];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self finishInputWithCode:textView.text];
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *codeStr = textView.text;
    codeStr = [codeStr stringByReplacingOccurrencesOfString:@" " withString:@""];//去空格
    if (codeStr.length >= self.codeLength) {
        codeStr = [codeStr substringToIndex:self.codeLength];
    }
    textView.text = codeStr;

    for (int i = 0; i < self.codeLength; i++) {
        UILabel *label = self.labelArr[i];

        if (!codeStr || codeStr.length == 0) {
            //第一个label边框为选中的颜色
            [self changeLabelBorderColorWithSelected:YES lineHidden:NO index:0];
            label.text = @"";
        }
        if (i == 0 && codeStr.length == 1) {
            [self changeLabelBorderColorWithSelected:YES lineHidden:NO index:i];
            label.text = codeStr;
        }
        if (i < codeStr.length) {
            //当前label边框为选中的颜色 设为no，填过数字的框为未选中颜色，只有当前框为选中颜色；设为yes，填过数字的框和当前框均为选中的颜色，为填过的为灰色框
            [self changeLabelBorderColorWithSelected:YES lineHidden:YES index:i];
            label.text = [codeStr substringWithRange:NSMakeRange(i, 1)];
        } else {
            if (i == codeStr.length) {
                [self changeLabelBorderColorWithSelected:YES lineHidden:NO index:i];
            } else {
                [self changeLabelBorderColorWithSelected:NO lineHidden:YES index:i];
            }
            label.text = @"";
        }
        
        if (i == self.codeLength-1 && label.text.length) {
            
            [textView resignFirstResponder];
        }
    }
    if (codeStr.length >= self.codeLength) {
    }
}

/**
 改变label边框颜色和光标

 @param selected 是否为当前输入的框
 @param hidden 光标是否显示
 @param index <#index description#>
 */
- (void)changeLabelBorderColorWithSelected:(BOOL)selected lineHidden:(BOOL)hidden index:(NSInteger)index {
    UILabel *label = self.labelArr[index];
    label.layer.borderColor = selected ? [UIColor customisMainColor].CGColor : NormalColor.CGColor;
    
//    CAShapeLayer *line = self.lineArr[index];
    UIView *line = self.lineArr[index];
    line.hidden = hidden;
}

- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];//必须写opacity才行。
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = 0.8;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];///没有的话是均匀的动画。
    return animation;
}

#pragma mark - lay
- (void)setCodeLength:(NSInteger)codeLength {
    _codeLength = codeLength;
}

- (NSMutableArray *)lineArr {
    if (!_lineArr) {
        _lineArr = [NSMutableArray array];
    }
    return _lineArr;
}

- (NSMutableArray *)labelArr {
    if (!_labelArr) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

@end
