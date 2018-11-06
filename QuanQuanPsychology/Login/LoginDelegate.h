//
//  LoginDelegate.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/6/1.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#ifndef LoginDelegate_h
#define LoginDelegate_h

@protocol LoginDelegate<NSObject>

-(void)loginClicked:(UIButton *)button;

@optional
-(void)verifyCodeClicked:(UIButton *)button;
-(void)forgetPasswordClicked:(UIButton *)button;
-(void)registerByPhoneClicked:(UIButton *)button;

@end



#endif /* LoginDelegate_h */
