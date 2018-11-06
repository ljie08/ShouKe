//
//  LiveVideoNodeView.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/25.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NodePlayBlock)(void);
@interface LiveVideoNodeView : UIView

@property (nonatomic, strong) NSString *nodetitle;/**< <#注释#> */

@property (nonatomic, copy) NodePlayBlock nodeBlock;/**< <#注释#> */

@end
