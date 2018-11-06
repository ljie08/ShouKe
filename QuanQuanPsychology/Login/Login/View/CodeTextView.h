//
//  CodeTextView.h
//  ShouKe
//
//  Created by Libra on 2018/10/15.
//  Copyright © 2018年 Libra. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CodeFinishBlock)(NSString *code);
@interface CodeTextView : UIView

@property (nonatomic, assign) NSInteger codeLength;/**< 验证码个数 */
@property (nonatomic, copy) CodeFinishBlock codeBlock;/**< <#注释#> */

@end
