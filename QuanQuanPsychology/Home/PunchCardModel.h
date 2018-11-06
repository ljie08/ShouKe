//
//  PunchCardModel.h
//  QuanQuanPsychology
//
//  Created by Libra on 2018/9/11.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface PunchCardModel : BasicModel

@property (nonatomic, assign) NSInteger signs;/**< 打卡次数 */
@property (nonatomic, assign) BOOL mySignFlag;/**< 是否可打卡 */

@end
