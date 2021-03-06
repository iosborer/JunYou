//
//  TFJunYou_RoomMemberListCell.h
//  TFJunYouChat
//
//  Created by p on 2018/7/3.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFJunYou_RoomMemberListCell : UITableViewCell

@property (nonatomic, strong) memberData *data;

@property (nonatomic, assign) int role;

@property (nonatomic, strong) roomData *room;

@property (nonatomic, strong) NSString *curManager;

@property (nonatomic, strong) UIView *lineView;

@end
