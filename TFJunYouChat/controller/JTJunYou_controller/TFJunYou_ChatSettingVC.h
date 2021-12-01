//
//  TFJunYou_ChatSettingVC.h
//  TFJunYouChat
//
//  Created by p on 2018/5/19.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
#import "TFJunYou_RoomObject.h"

@interface TFJunYou_ChatSettingVC : TFJunYou_admobViewController

@property (nonatomic,strong) TFJunYou_UserObject *user;
@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;
@property (nonatomic,strong) roomData * room;

@end
