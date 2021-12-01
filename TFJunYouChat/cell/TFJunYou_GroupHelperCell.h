//
//  TFJunYou_GroupHelperCell.h
//  TFJunYouChat
//
//  Created by 1 on 2019/5/29.
//  Copyright © 2019年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFJunYou_HelperModel.h"

NS_ASSUME_NONNULL_BEGIN


@class TFJunYou_GroupHelperCell;

@protocol TFJunYou_GroupHelperCellDelegate <NSObject>

- (void)groupHelperCell:(TFJunYou_GroupHelperCell *)cell clickAddBtnWithIndex:(NSInteger)index;

@end


@interface TFJunYou_GroupHelperCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSArray *groupHelperArr;

@property (weak, nonatomic) id <TFJunYou_GroupHelperCellDelegate>delegate;


- (void)setDataWithModel:(TFJunYou_HelperModel *)model;


@end

NS_ASSUME_NONNULL_END
