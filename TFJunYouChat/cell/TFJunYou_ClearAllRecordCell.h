//
//  TFJunYou_ClearAllRecordCell.h
//  TFJunYouChat
//
//  Created by lifengye on 2020/9/6.
//  Copyright © 2019 zengwOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFJunYou_ClearAllRecordCell : UITableViewCell
@property(nonatomic ,strong)NSString *titleString;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
