//
//  QuanIAPManager.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/12/4.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, IAPFiledCode) {
    /**
     *  苹果返回错误信息
     */
    IAP_FILEDCOED_APPLECODE = 0,
    
    /**
     *  用户禁止应用内付费购买
     */
    IAP_FILEDCOED_NORIGHT = 1,
    
    /**
     *  商品为空
     */
    IAP_FILEDCOED_EMPTYGOODS = 2,
    /**
     *  无法获取产品信息，请重试
     */
    IAP_FILEDCOED_CANNOTGETINFORMATION = 3,
    /**
     *  购买失败，请重试
     */
    IAP_FILEDCOED_BUYFILED = 4,
    /**
     *  用户取消交易
     */
    IAP_FILEDCOED_USERCANCEL = 5,
    
    /**
     *  用户上次交易未结束
     */
    IAP_FILEDCOED_LASTOREDERNOTFINISHED = 6
    
};


@protocol IAPRequestResultsDelegate <NSObject>

- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error; //失败

@optional
-(void)transactionSuccess;

@end

@interface QuanIAPManager : NSObject

@property (nonatomic, weak) id<IAPRequestResultsDelegate>delegate;

@property (assign,nonatomic) BOOL livePay;

+(instancetype)sharedInstance;


/**
 启动工具
 */
- (void)startManager;

/**
 结束工具
 */
- (void)stopManager;

/**
 请求商品列表
 */
- (void)requestProductWithId:(NSString *)productId andOrderID:(NSString *)orderID;



@end
