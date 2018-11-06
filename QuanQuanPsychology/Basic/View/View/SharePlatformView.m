//
//  SharePlatformView.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/1/27.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "SharePlatformView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShareModel.h"

@interface SharePlatformView()

@property (strong, nonatomic) UILabel *wechatLabel;

@property (strong, nonatomic) UIButton *wechat;

@property (strong, nonatomic) UILabel *momentsLabel;

@property (strong, nonatomic) UIButton *moments;

@property (strong, nonatomic) UILabel *qqLabel;

@property (strong, nonatomic) UIButton *qq;

@property (strong, nonatomic) UILabel *weiboLabel;

@property (strong, nonatomic) UIButton *weibo;

@property (assign, nonatomic) BOOL isUMSuccess;

@property (assign, nonatomic) NSInteger platform;

@end

@implementation SharePlatformView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initUI];

    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initUI];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateUI];
}

-(void)initUI{
    
    /* Wechat */
    
    self.wechatLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wechatLabel.text = @"微信";
    self.wechatLabel.textAlignment = NSTextAlignmentCenter;
    self.wechatLabel.textColor = [UIColor colorwithHexString:@"#333333"];
    self.wechatLabel.font = [UIFont systemFontOfSize:14];
    self.wechatLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.wechatLabel];
    
    self.wechat = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.wechat setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.wechat addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
   self. wechat.tag = 1;
    [self addSubview:self.wechat];
    
    /* Moment */
    
    self.momentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.momentsLabel.text = @"朋友圈";
    self.momentsLabel.textAlignment = NSTextAlignmentCenter;
    self.momentsLabel.textColor = [UIColor colorwithHexString:@"#333333"];
    self.momentsLabel.font = [UIFont systemFontOfSize:14];
    self.momentsLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.momentsLabel];
    
    self.moments = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.moments setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    [self.moments addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    self.moments.tag = 2;
    [self addSubview:self.moments];
    
    /* QQ */
    
    self.qqLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.qqLabel.text = @"QQ";
    self.qqLabel.textAlignment = NSTextAlignmentCenter;
    self.qqLabel.textColor = [UIColor colorwithHexString:@"#333333"];
    self.qqLabel.font = [UIFont systemFontOfSize:14];
    self.qqLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.qqLabel];
    
    self.qq = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [self.qq addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    self.qq.tag = 3;
    [self addSubview:self.qq];
    
    /* Weibo */
    
    self.weiboLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.weiboLabel.text = @"微博";
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textColor = [UIColor colorwithHexString:@"#333333"];
    self.weiboLabel.font = [UIFont systemFontOfSize:14];
    self.weiboLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.weiboLabel];
    
    self.weibo = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.weibo setBackgroundImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    [self.weibo addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
    self.weibo.tag = 4;
    [self addSubview:self.weibo];
}

-(void)updateUI{
    
    //    CGFloat margin = self.frame.size.width * 0.05;
    //    CGFloat gap = self.frame.size.width * 0.06;
    CGFloat iconSize = self.frame.size.width * 0.16;
    CGFloat margin = (self.frame.size.width - iconSize * 4) / 5;
    
    CGFloat labelY = iconSize + 5;
    //        CGFloat iconY = frame.size.height - labelY - 4 - iconSize;
    
    /* Wechat */
    
    self.wechatLabel.frame = CGRectMake(margin, labelY, iconSize, 20);
    self.wechat.frame = CGRectMake(margin, 0, iconSize, iconSize);
    
    /* Moment */
    
    CGFloat momentX = margin + iconSize + margin;
    
    self.momentsLabel.frame = CGRectMake(momentX, labelY, iconSize, 20);
    self.moments.frame = CGRectMake(momentX, 0, iconSize, iconSize);
    
    /* QQ */
    CGFloat qqX = margin + iconSize * 2 + margin * 2;
    
    self.qqLabel.frame = CGRectMake(qqX, labelY, iconSize, 20);
    self.qq.frame = CGRectMake(qqX, 0, iconSize, iconSize);

    
    /* Weibo */
    CGFloat weiboX = margin + iconSize * 3 + margin * 3;
    
    self.weiboLabel.frame = CGRectMake(weiboX, labelY, iconSize, 20);
    self.weibo.frame = CGRectMake(weiboX, 0, iconSize, iconSize);
}

#pragma mark - Button Action
-(void)shareResult:(UIButton *)button{
    
    /**
     设置分享
     
     @param data 分享返回信息
     @param error 失败信息
     @param UMSocialPlatformType 分享平台
     */
    
    self.platform = button.tag - 1;
    
    UMSocialPlatformType shareType;
    
    switch (button.tag) {
        case 1:
            shareType = UMSocialPlatformType_WechatSession;
            break;
            
        case 2:
            shareType = UMSocialPlatformType_WechatTimeLine;
            break;
            
        case 3:
            shareType = UMSocialPlatformType_QQ;
            break;
            
        case 4:
            shareType = UMSocialPlatformType_Sina;
            break;
            
        default:
            shareType = UMSocialPlatformType_WechatSession;
            break;
            
    }
    
    
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:[self createShareMaterial] currentViewController:self.currentVC completion:^(id data, NSError *error) {
        if (error) {
            self.isUMSuccess = NO;
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([self.delegate respondsToSelector:@selector(getShareSucessScore)]) {
                [self.delegate getShareSucessScore];
            }
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                
                
                NSLog(@"res - %@",resp.message);
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
            
            self.isUMSuccess = YES;
            
            if (self.isUMSuccess) {
                [self UMShareSuccess];
            }
            
        }
        
    }];
    
    self.sharePlatformSeleted();

}

-(UMSocialMessageObject *)createShareMaterial{
    
    if (self.shareMaterialDifferent) {
        
        ShareModel *share = self.materials[self.platform];
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:share.shareTitle descr:share.shareSubTitle thumImage:self.shareIcon];
        
        //设置网页地址
        shareObject.webpageUrl = [self.shareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        return messageObject;
        
    } else {
        /*
         创建网页内容对象
         根据不同需求设置不同分享内容，一般为图片，标题，描述，url
         */
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareSubTitle thumImage:self.shareIcon];
        
        //设置网页地址
        shareObject.webpageUrl = [self.shareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        return messageObject;
    }
}

-(void)UMShareSuccess{
    if ([_delegate respondsToSelector:@selector(shareSuccess)]) {
        [_delegate shareSuccess];
    }
}
@end
