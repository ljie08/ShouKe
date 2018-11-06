//
//  PopupModel.h
//  QuanQuan
//
//  Created by Jocelyn on 2018/4/17.
//  Copyright © 2018年 QuanQuan. All rights reserved.
//

#import "BasicModel.h"

@interface PopupModel : BasicModel

@property (strong, nonatomic) NSString *popupStartTime;/* 弹窗开始时间 */

@property (strong, nonatomic) NSString *popupEndTime;/* 弹窗结束时间 */

@property (strong, nonatomic) NSString *url;/* 弹窗链接 */

@property (strong, nonatomic) NSString *imagePath;/* 弹窗图片路径 */

-(instancetype)initWithDict:(NSDictionary *)dict;

@end
