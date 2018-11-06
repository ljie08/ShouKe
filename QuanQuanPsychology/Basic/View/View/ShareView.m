//
//  ShareView.m
//  QuanQuan
//
//  Created by Jocelyn on 2016/12/26.
//  Copyright © 2016年 QuanQuan. All rights reserved.
//

#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "ShareModel.h"

@interface ShareView ()

@property (strong, nonatomic) UIView *basicView;

//@property (assign, nonatomic) BOOL isUMSuccess;
//
//@property (assign, nonatomic) NSInteger platform;

@end

@implementation ShareView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView:)];
        [self addGestureRecognizer:tap];
        
//        [self addNotification];

        self.basicView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 168)];
        self.basicView.backgroundColor = [UIColor colorwithHexString:@"#F4F4F4"];
        [self addSubview:self.basicView];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, frame.size.height - 168, self.basicView.frame.size.width, self.basicView.frame.size.height);    }];
        
        /* 取消按钮 */
        CGFloat buttonHeight = 44;
        CGFloat buttonY = self.basicView.frame.size.height - buttonHeight;
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, frame.size.width, buttonHeight)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorwithHexString:@"#333333"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cancelBtn.backgroundColor = [UIColor colorwithHexString:@"#ffffff"];
        [cancelBtn addTarget:self action:@selector(shareCancel:) forControlEvents:UIControlEventTouchUpInside];
        [self.basicView addSubview:cancelBtn];
        
//        CGFloat margin = self.basicView.frame.size.width * 0.083;
//        CGFloat gap = self.basicView.frame.size.width * 0.067;
        CGFloat iconSize = self.basicView.frame.size.width * 0.159;
        CGFloat labelY = self.basicView.frame.size.height - cancelBtn.frame.size.height - 20 - 20;
        CGFloat iconY = self.basicView.frame.size.height - labelY - 4 - iconSize;
        
        self.platformView = [[SharePlatformView alloc] initWithFrame:CGRectMake(0, iconY, self.basicView.frame.size.width, buttonY)];
        
        __weak ShareView *weakSelf = self;
        
        self.platformView.sharePlatformSeleted = ^{
            [weakSelf removeFromSuperview];
        };
        
        [self.basicView addSubview:self.platformView];

//        /* Wechat */
//
//        UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, labelY, iconSize, 20)];
//        wechatLabel.text = @"微信";
//        wechatLabel.textAlignment = NSTextAlignmentCenter;
//        wechatLabel.textColor = [UIColor colorwithHexString:@"#333333"];
//        wechatLabel.font = [UIFont systemFontOfSize:14];
//        [self.basicView addSubview:wechatLabel];
//
//        UIButton *wechat = [[UIButton alloc] initWithFrame:CGRectMake(margin, iconY, iconSize, iconSize)];
//        [wechat setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//        [wechat addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
//        wechat.tag = 1;
//        [self.basicView addSubview:wechat];
//
//        /* Moment */
//
//        CGFloat momentX = margin + iconSize + gap;
//
//        UILabel *momentLabel = [[UILabel alloc] initWithFrame:CGRectMake(momentX, labelY, iconSize, 20)];
//        momentLabel.text = @"朋友圈";
//        momentLabel.textAlignment = NSTextAlignmentCenter;
//        momentLabel.textColor = [UIColor colorwithHexString:@"#333333"];
//        momentLabel.font = [UIFont systemFontOfSize:14];
//        [self.basicView addSubview:momentLabel];
//
//        UIButton *moment = [[UIButton alloc] initWithFrame:CGRectMake(momentX, iconY, iconSize, iconSize)];
//        [moment setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
//        [moment addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
//        moment.tag = 2;
//        [self.basicView addSubview:moment];
//
//        /* QQ */
//        CGFloat qqX = margin + iconSize * 2 + gap * 2;
//
//        UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(qqX, labelY, iconSize, 20)];
//        qqLabel.text = @"QQ";
//        qqLabel.textAlignment = NSTextAlignmentCenter;
//        qqLabel.textColor = [UIColor colorwithHexString:@"#333333"];
//        qqLabel.font = [UIFont systemFontOfSize:14];
//        [self.basicView addSubview:qqLabel];
//
//        UIButton *qq = [[UIButton alloc] initWithFrame:CGRectMake(qqX, iconY, iconSize, iconSize)];
//        [qq setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
//        [qq addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
//        qq.tag = 3;
//        [self.basicView addSubview:qq];
//
//        /* Weibo */
//        CGFloat weiboX = margin + iconSize * 3 + gap * 3;
//
//        UILabel *weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(weiboX, labelY, iconSize, 20)];
//        weiboLabel.text = @"微博";
//        weiboLabel.textAlignment = NSTextAlignmentCenter;
//        weiboLabel.textColor = [UIColor colorwithHexString:@"#333333"];
//        weiboLabel.font = [UIFont systemFontOfSize:14];
//        [self.basicView addSubview:weiboLabel];
//
//        UIButton *weibo = [[UIButton alloc] initWithFrame:CGRectMake(weiboX, iconY, iconSize, iconSize)];
//        [weibo setBackgroundImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
//        [weibo addTarget:self action:@selector(shareResult:) forControlEvents:UIControlEventTouchUpInside];
//        weibo.tag = 4;
//        [self.basicView addSubview:weibo];
        
    }
    return self;
}

#pragma mark - Button Action
//-(void)shareResult:(UIButton *)button{
//
//    /**
//     设置分享
//
//     @param data 分享返回信息
//     @param error 失败信息
//     @param UMSocialPlatformType 分享平台
//     */
//
//    self.platform = button.tag - 1;
//
//    UMSocialPlatformType shareType;
//
//    switch (button.tag) {
//        case 1:
//            shareType = UMSocialPlatformType_WechatSession;
//            break;
//
//        case 2:
//            shareType = UMSocialPlatformType_WechatTimeLine;
//            break;
//
//        case 3:
//            shareType = UMSocialPlatformType_QQ;
//            break;
//
//        case 4:
//            shareType = UMSocialPlatformType_Sina;
//            break;
//
//        default:
//            shareType = UMSocialPlatformType_WechatSession;
//            break;
//
//    }
//
//
//    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:[self createShareMaterial] currentViewController:self.currentVC completion:^(id data, NSError *error) {
//        if (error) {
//            self.isUMSuccess = NO;
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//
//                UMSocialShareResponse *resp = data;
//
//
//                NSLog(@"res - %@",resp.message);
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//
//            self.isUMSuccess = YES;
//
//            if (self.isUMSuccess) {
//                [self UMShareSuccess];
//            }
//
//            [self removeFromSuperview];
//        }
//    }];
//
//
//}
//
//-(UMSocialMessageObject *)createShareMaterial{
//
//    if (self.shareMaterialDifferent) {
//
//        ShareModel *share = self.materials[self.platform];
//
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:share.shareTitle descr:share.shareSubTitle thumImage:self.shareIcon];
//
//        //设置网页地址
//        shareObject.webpageUrl = [self.shareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        //创建分享消息对象
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//
//        return messageObject;
//
//    } else {
//        /*
//         创建网页内容对象
//         根据不同需求设置不同分享内容，一般为图片，标题，描述，url
//         */
//        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareSubTitle thumImage:self.shareIcon];
//
//        //设置网页地址
//        shareObject.webpageUrl = [self.shareURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//        //创建分享消息对象
//        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//        //分享消息对象设置分享内容对象
//        messageObject.shareObject = shareObject;
//
//        return messageObject;
//    }
//}
//
-(void)shareCancel:(UIButton *)button{

    [UIView animateWithDuration:0.5 animations:^{
        self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height, self.basicView.frame.size.width, self.basicView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.basicView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [self removeFromSuperview];
        }];
    }];
}

#pragma mark - Gesture
-(void)removeShareView:(UITapGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.basicView.frame = CGRectMake(self.basicView.frame.origin.x, self.frame.size.height, self.basicView.frame.size.width, self.basicView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.basicView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            [self removeFromSuperview];
        }];
    }];
}

//-(void)UMShareSuccess{
//    if ([_delegate respondsToSelector:@selector(shareSuccess)]) {
//        [_delegate shareSuccess];
//    }
//}

@end
