//
//  UserTypeCell.h
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserCardBlock)(void);
typedef void(^UserCourseBlock)(void);
typedef void(^UserMistakesBlock)(void);

@interface UserTypeCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

@property (nonatomic, copy) UserCardBlock cardBlock;/**< <#注释#> */
@property (nonatomic, copy) UserCourseBlock courseBlock;/**< <#注释#> */
@property (nonatomic, copy) UserMistakesBlock misstakeBlock;/**< <#注释#> */

@end
