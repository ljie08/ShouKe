//
//  CPStudyRecordModel.h
//  QuanQuanPsychology
//
//  Created by Jocelyn on 2018/7/24.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "BasicModel.h"
#import "CardPackageModel.h"


@interface CPStudyRecordModel : BasicModel <NSCoding>

/*  */
@property (strong, nonatomic) CardPackageModel *cp;

/*  */
@property (copy, nonatomic) NSString *cardID;

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
