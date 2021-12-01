//
//  XMG_FriendCirleCell.h
//  JTManyChildrenSongs
//
//  Created by os on 2020/12/3.
//  Copyright © 2020 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMG_FriendCirleCell : UITableViewCell
@property (nonatomic,strong) TFJunYou_UserBaseObj *userBaseModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
