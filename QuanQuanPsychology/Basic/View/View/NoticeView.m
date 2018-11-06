//
//  NoticeView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/27.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "NoticeView.h"

@interface NoticeView()

@property (strong, nonatomic) UIView *basicView;

@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@property (strong, nonatomic) UILabel *label;

@property (strong, nonatomic) UIButton *leftBtn;

@property (strong, nonatomic) UIButton *rightBtn;

@property (assign, nonatomic) NoticeButtonAction action;

@property (assign, nonatomic) NoticeViewType currentType;

/* */
@property (assign, nonatomic) CGSize basicSize;

/* */
@property (assign, nonatomic) NSInteger buttonCount;



@end

@implementation NoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.currentType) {
        
        CGFloat width = self.basicSize.width + 10;
        CGFloat x = (ScreenWidth - width) / 2;
        
        if (x < 0) {
            x = 0;
        }
        
        CGFloat height;
        
        UIView *basicView = [self viewWithTag:100];
        
        switch (self.currentType) {
            case NoticeViewTypeText:
                {
                    height = self.basicSize.height + 10 + 10;
                    self.label.frame = CGRectMake(5, 10, self.basicSize.width, self.basicSize.height);
                }
                break;
                
            case NoticeViewTypeTextButton:
                {
                    
                    if (self.buttonCount == 1) {
                        if (width < 120) {
                            width = 120;
                        }
                    } else if (self.buttonCount == 2) {
                        if (width < 230) {
                            width = 230;
                        }
                    }
                    
                    
                    height = self.basicSize.height + 30 + 10 + 10 + 10;
                    x = (ScreenWidth - width) / 2;
                    
                    self.label.frame = CGRectMake((width - self.basicSize.width) / 2, 10, self.basicSize.width, self.basicSize.height);
                    
                    for (int i = 0; i < self.buttonCount; i++) {
                        UIView *view = [self viewWithTag:i];
                        if ([view isKindOfClass:[UIButton class]]) {
                            UIButton *button = (UIButton *)view;
                            
                            if (i == 1) {
                                button.frame = CGRectMake((width - 100) / 2, self.basicSize.height + 10 + 10, 100, 30);
                            } else {
                                button.frame = CGRectMake(i * 100 + 10, self.basicSize.height + 10 + 10, 100, 30);
                            }
                        }
                    }
                    
                }
                
                break;
                
            case NoticeViewTypeIndicatorText:
                {

                    height = self.basicSize.height + 30 + 10 + 10 + 10;
                    self.label.frame = CGRectMake(5, 30 + 10 + 10, self.basicSize.width, self.basicSize.height);
                    self.indicator.frame = CGRectMake((width - 30) / 2, 10, 30, 30);

                }
                break;
        }
        
        
        basicView.frame = CGRectMake(x, 0, width, height);

    }
    

}

-(void)setSuccess:(BOOL)success{
    _success = success;
    if (success) {
        [self.indicator stopAnimating];
    } else {
        [self.indicator startAnimating];
    }
}

-(void)setNoticeWithType:(NoticeViewType)type
                  notice:(NSString *)notice
               btnTitles:(NSArray *)titles
               btnAction:(NoticeButtonAction)action{
    
    self.action = action;
    self.currentType = type;
    
    CGSize lblSize = [notice sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize size = CGSizeMake(ceilf(lblSize.width), ceilf(lblSize.height));
    
    CGFloat width = size.width + 10;
    CGFloat x = (ScreenWidth - width) / 2;
    
    if (x < 0) {
        x = 0;
    }
    
    self.basicSize = size;
    
    UIView *basicView = [[UIView alloc] init];
    basicView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    basicView.layer.cornerRadius = 4;
    basicView.tag = 100;
    [self addSubview:basicView];
    
    
    switch (type) {
        case NoticeViewTypeText:
        {
            CGFloat height = size.height + 10 + 10;
            
            basicView.frame = CGRectMake(x, 0, width, height);
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, size.width, size.height)];
            self.label.numberOfLines = 0;
            self.label.text = notice;
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:13];
            self.label.adjustsFontSizeToFitWidth = YES;
            [basicView addSubview:self.label];
        }
            break;
            
        case NoticeViewTypeTextButton:
        {
            
            if (titles.count == 1) {
                if (width < 120) {
                    width = 120;
                }
            } else if (titles.count == 2) {
                if (width < 230) {
                    width = 230;
                }
            }
            
            self.buttonCount = titles.count;
            
            CGFloat height = size.height + 30 + 10 + 10 + 10;
            x = (ScreenWidth - width) / 2;
            basicView.frame = CGRectMake(x, 0, width, height);
            
            self.label = [[UILabel alloc] initWithFrame:CGRectMake((width - size.width) / 2, 10, size.width, size.height)];
            self.label.numberOfLines = 0;
            self.label.text = notice;
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:13];
            [basicView addSubview:self.label];
            
            
            for (int i = 0; i < titles.count; i++) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                if (titles.count == 1) {
                    button.frame = CGRectMake((width - 100) / 2, size.height + 10 + 10, 100, 30);
                } else {
                    button.frame = CGRectMake(i * 100 + 10, size.height + 10 + 10, 100, 30);
                }
                [button setTitle:titles[i] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:13];
                button.tag = i;
                button.layer.cornerRadius = 4;
                button.layer.borderWidth = 1;
                button.layer.borderColor = [UIColor whiteColor].CGColor;
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [basicView addSubview:button];
            }

        }
            break;
            
        case NoticeViewTypeIndicatorText:
        {
        
            CGFloat height = size.height + 30 + 10 + 10 + 10;
            basicView.frame = CGRectMake(x, 0, width, height);
            
            self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self.indicator startAnimating];
            self.indicator.frame = CGRectMake((width - 30) / 2, 10, 30, 30);
            [basicView addSubview:self.indicator];
            
            self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 30 + 10 + 10, size.width, size.height)];
            self.label.numberOfLines = 0;
            self.label.text = notice;
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
            self.label.font = [UIFont systemFontOfSize:13];
            [basicView addSubview:self.label];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - actions
-(void)buttonAction:(UIButton *)button{
    [self removeFromSuperview];
    self.completionHandler(button,self.action);
}

-(void)dismissViewAfterDelay:(NSTimeInterval)time{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}

@end
