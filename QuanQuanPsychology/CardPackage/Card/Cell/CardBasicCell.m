//
//  CardBasicCell.m
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/28.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import "CardBasicCell.h"

@interface CardBasicCell ()<UIScrollViewDelegate>

@property (assign, nonatomic) BOOL isFront;

@property (strong, nonatomic) CardModel *card;

@end

@implementation CardBasicCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self initUI];
    
}

-(void)initUI{
    
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.12].CGColor;
    self.layer.shadowRadius = 7;
    self.layer.shadowOpacity = 1;
    self.layer.masksToBounds = NO;
    
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

//    [jScript stringByAppendingString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
//    [jScript stringByAppendingString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择


    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];

    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    //    WKPreferences *preference = [[WKPreferences alloc]init];
    //    // 设置字体大小(最小的字体大小)
    //    preference.minimumFontSize = 20;
    //    // 设置偏好设置对象

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    //    wkWebConfig.preferences = preference;

//    double height = round(ScreenHeight * 0.84 * 0.77);
    
    _cardWeb = [[WKWebView alloc] initWithFrame:CGRectMake(20, 30, self.frame.size.width - 20 * 2, self.frame.size.height * 0.8) configuration:wkWebConfig];
    _cardWeb.userInteractionEnabled = NO;
    _cardWeb.scrollView.delegate = self;
    _cardWeb.scrollView.bounces = NO;
    _cardWeb.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    _cardWeb.frame = CGRectMake(20, 30, self.frame.size.width - 20 * 2, self.frame.size.height * 0.8 - 30);
    [self.contentView addSubview:_cardWeb];
    [self.contentView addGestureRecognizer:_cardWeb.scrollView.panGestureRecognizer];

    _exerciseBtn = [[MainGreenButton alloc] initWithFrame:CGRectMake((self.frame.size.width - 200 ) / 2, _cardWeb.frame.size.height + _cardWeb.frame.origin.y, 200, 45)];
    [_exerciseBtn setTitle:@"去练习" forState:UIControlStateNormal];
    [_exerciseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _exerciseBtn.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    [_exerciseBtn addTarget:self action:@selector(doExercise:) forControlEvents:UIControlEventTouchUpInside];
    _exerciseBtn.layer.cornerRadius = 45 / 2;
    [self.contentView addSubview:_exerciseBtn];

    self.webMask = [[UIImageView alloc] initWithFrame:CGRectMake(20, _exerciseBtn.frame.origin.y - 30, _cardWeb.frame.size.width, 30)];
    self.webMask.image = [UIImage imageNamed:@"webmask"];
    [self.contentView addSubview:self.webMask];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];

    self.cardWeb.frame = CGRectMake(20, 30, self.frame.size.width - 20 * 2, self.frame.size.height * 0.8);
    self.exerciseBtn.frame = CGRectMake((self.frame.size.width - 200 ) / 2, self.cardWeb.frame.size.height + self.cardWeb.frame.origin.y + 10, 200, 45);
    
    self.webMask.frame = CGRectMake(20, self.exerciseBtn.frame.origin.y - 30, self.cardWeb.frame.size.width, 30);
}

#pragma mark -
-(void)setUIStatus:(BOOL)isFront{
    self.cardWeb.hidden = isFront ? NO : YES;
    self.exerciseBtn.hidden = isFront ? NO : YES;
    self.webMask.hidden = isFront ? NO : YES;
    self.isFront = isFront;
}

-(void)setValueWithModel:(CardModel *)card front:(BOOL)isFront{
    
    self.card = card;
    [self.cardWeb loadHTMLString:self.card.cardAnalysis baseURL:nil];

    if (card.hasQuestion) {
        [self.exerciseBtn setTitle:@"去练习" forState:UIControlStateNormal];
        self.exerciseBtn.backgroundColor = [UIColor customisMainGreen];
        [self.exerciseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.exerciseBtn.enabled = YES;
    } else {
        [self.exerciseBtn setTitle:@"已掌握" forState:UIControlStateNormal];
        
        if ([card.cardIsComplete isEqualToString:@"1"]){
            self.exerciseBtn.backgroundColor = [UIColor colorwithHexString:@"#E8E8E8"];
            [self.exerciseBtn setTitleColor:[UIColor colorwithHexString:@"#8D8D8D"] forState:UIControlStateNormal];
            self.exerciseBtn.enabled = NO;
        } else {
            self.exerciseBtn.backgroundColor = [UIColor customisMainGreen];
            [self.exerciseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.exerciseBtn.enabled = YES;
        }
    }
    
}

-(UIImage *)switchStarToAppropriateImage:(NSString *)star{
    
    NSInteger number = [star integerValue];
    
    UIImage *image;
    
    switch (number) {
        case 1:
            image = [UIImage imageNamed:@"star1"];
            break;
            
        case 2:
            image = [UIImage imageNamed:@"star2"];
            break;
            
        case 3:
            image = [UIImage imageNamed:@"star3"];
            break;
            
        case 4:
            image = [UIImage imageNamed:@"star4"];
            break;
            
        case 5:
            image = [UIImage imageNamed:@"star5"];
            break;
            
    }
    
    return image;
    
}

#pragma mark - Button Action
-(void)doExercise:(UIButton *)button{
    
    if ([_delegate respondsToSelector:@selector(doCardExercise:)]) {
        [_delegate doCardExercise:button];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    double value = round(ScreenHeight * 0.84 * 0.77);
    double height = round(scrollView.contentSize.height);
    double offset = round(scrollView.contentOffset.y);

    NSLog(@"%f-%f",scrollView.contentSize.height,scrollView.contentOffset.y);
    
    if (self.isFront) {
        if (height - offset <=  value - 3 || height - offset <=  value + 3) {
            self.webMask.hidden = YES;
        } else {
            self.webMask.hidden = NO;
            
        }
    }
    
    
}

-(void)dealloc{
    self.cardWeb.scrollView.delegate = nil;
}

@end
