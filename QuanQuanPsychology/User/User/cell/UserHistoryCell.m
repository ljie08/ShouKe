//
//  UserHistoryCell.m
//  QuanQuanPsychology
//
//  Created by user on 2018/9/7.
//  Copyright © 2018年 HuaCaiQuanQuan. All rights reserved.
//

#import "UserHistoryCell.h"
#import "UserHisetoryItem.h"

@interface UserHistoryCell()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation UserHistoryCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview historyArr:(NSArray *)historyArr {
    static NSString *cellid = @"UserHistoryCell";
    UserHistoryCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UserHistoryCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.historyArr = historyArr;
        [cell layoutCollectionview];
    }
    
    return cell;
}

- (void)layoutCollectionview {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(205, 115);
//    CGFloat width;
//    width = ScreenWidth;
//    if (self.historyArr.count > 0) {
//    } else {
//        width = 200*self.historyArr.count;
//    }
    self.historyCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 115) collectionViewLayout:flow];
    self.historyCollectionview.backgroundColor = [UIColor clearColor];
    self.historyCollectionview.delegate = self;
    self.historyCollectionview.dataSource = self;
    self.historyCollectionview.showsHorizontalScrollIndicator = NO;
    [self.historyCollectionview registerNib:[UINib nibWithNibName:@"UserHisetoryItem" bundle:nil] forCellWithReuseIdentifier:@"UserHisetoryItem"];
    [self.contentView addSubview:self.historyCollectionview];
}

- (NSArray *)historyArr {
    if (!_historyArr) {
        _historyArr = [NSArray array];
    }
    return _historyArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 21, 21)];
    imgV.image = [UIImage imageNamed:@"user_history"];
    [view addSubview:imgV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgV.frame)+7, 10, 100, 21)];
    label.text = @"观看历史";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor customisDarkGreyColor];
    [view addSubview:label];
    
    [self.contentView addSubview:view];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyArr.count;
    //    return 24;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserHisetoryItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserHisetoryItem" forIndexPath:indexPath];
    [cell setDataWithModel:self.historyArr[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        self.block(indexPath.row);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
