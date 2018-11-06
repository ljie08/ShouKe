//
//  UserHistoryCell.h
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserHistoryBlock)(NSInteger index);

@interface UserHistoryCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview historyArr:(NSArray *)historyArr;
@property (nonatomic, strong) NSArray *historyArr;/**< 观看历史 */

@property (nonatomic, copy) UserHistoryBlock block;/**< <#注释#> */

@property (nonatomic, strong) UICollectionView *historyCollectionview;
- (void)layoutCollectionview;

@end
