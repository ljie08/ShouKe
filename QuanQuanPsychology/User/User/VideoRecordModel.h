//
//  VideoRecordModel.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface VideoRecordModel : BasicModel

@property (nonatomic, copy) NSString *p_name;/**< <#注释#> */
@property (nonatomic, copy) NSString *course_id;/**< <#注释#> */
@property (nonatomic, copy) NSString *v_id;/**< <#注释#> */
@property (nonatomic, copy) NSString *complete_time;/**< <#注释#> */
@property (nonatomic, copy) NSString *title;/**< <#注释#> */
@property (nonatomic, copy) NSString *play_background_pic_url;/**< <#注释#> */
@property (nonatomic, copy) NSString *NAME;/**< <#注释#> */
@property (nonatomic, copy) NSString *pid;/**< <#注释#> */

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
