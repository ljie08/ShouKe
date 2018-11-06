//
//  PlayRecordModel.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface PlayRecordModel : BasicModel

@property (nonatomic, copy) NSString *cousre_id;/**< <#注释#> */
@property (nonatomic, copy) NSString *video_id;/**< <#注释#> */
@property (nonatomic, assign) NSTimeInterval playtime;/**< <#注释#> */

@end
