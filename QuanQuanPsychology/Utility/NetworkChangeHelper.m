//
//  NetworkChangeHelper.m
//  QuanQuan
//
//  Created by Jocelyn on 2018/5/9.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "NetworkChangeHelper.h"

@interface NetworkChangeHelper()

@property (strong, nonatomic) Reachability *reachability;

@end

@implementation NetworkChangeHelper

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [self addNotification];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - add Observer
-(void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

- (void)networkStateChange{
    [self checkNetworkStatus];
}

- (void)becomeActive{
    self.becameActiveHelper();
    [self checkNetworkStatus];
}

- (void)resignActive{
    self.resignActiveHelper();
}

-(void)checkNetworkStatus{
    NetworkStatus status = [self.reachability currentReachabilityStatus];
    self.networkChange(status);
}

-(NetworkStatus)currentNetwork{
    return [self.reachability currentReachabilityStatus];
}

@end
