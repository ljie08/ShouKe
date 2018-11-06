//
//  CardPackageModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2017/11/27.
//  Copyright © 2017年 QuanQuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardPackageDefine.h"

@interface CardPackageModel : BasicModel <NSCoding>

@property (assign, nonatomic) BOOL ownCardPackage;/* 是否拥有卡包 */

@property (copy, nonatomic) NSString *courseName;/* 科目名称 */

@property (copy, nonatomic) NSString *courseLevel;/* 科目等级 */

@property (copy, nonatomic) NSString *cpID;/* 卡包ID */

@property (copy, nonatomic) NSString *cpTitle;/* 卡包名称 */

@property (copy, nonatomic) NSString *cpTitlePic;/* 卡包封面图 */

@property (copy, nonatomic) NSString *cpSubTitle;/* 卡包二级标题 */

@property (assign, nonatomic) CardPackageType cpType;/* 卡包类型 */

@property (copy, nonatomic) NSString *cpOwners;/* 卡包拥有者 */

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
