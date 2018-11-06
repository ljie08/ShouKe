//
//  CardPackageDetailModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/27.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardPackageDefine.h"


@interface CardPackageDetailModel : BasicModel <NSCoding>

@property (assign, nonatomic) BOOL ownCardPackage;/* 是否拥有卡包 */

@property (copy, nonatomic) NSString *cpID;/* 卡包ID */

@property (copy, nonatomic) NSString *cpTitle;/* 卡包名称 */

@property (copy, nonatomic) NSString *cpBackgroundPic;/* 卡包背景图 */

@property (copy, nonatomic) NSString *cpDescription;/* 卡包介绍*/

@property (copy, nonatomic) NSString *courseName;/* 科目名称 */

@property (copy, nonatomic) NSString *courseLevel;/* 科目等级 */

@property (copy, nonatomic) NSString *examQuesTime;/* 考题年份 */

@property (copy, nonatomic) NSString *subjectName;/* 教材名称 */

@property (copy, nonatomic) NSString *targetPerson;/* 目标群体 */

@property (assign, nonatomic) CardPackageType cpType;/* 卡包类型 */

@property (copy, nonatomic) NSString *cpAmount;/* 卡包价格 */

@property (copy, nonatomic) NSString *cpProductID;/* 卡包APPStore内购ID*/

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
