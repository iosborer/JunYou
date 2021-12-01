//
//  TFJunYou_SearchRecordCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/6.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TFJunYou_SearchRecordCell;
@protocol TFJunYou_SearchRecordCellDelegate <NSObject>

- (void)deleteCell:(TFJunYou_SearchRecordCell *)cell;

@end


@interface TFJunYou_SearchRecordCell : UITableViewCell
@property (nonatomic,strong)UIButton *deleteBtn;
@property (nonatomic,weak)id<TFJunYou_SearchRecordCellDelegate> delegate;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
