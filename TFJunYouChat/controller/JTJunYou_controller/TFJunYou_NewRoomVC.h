//
//  TFJunYou_NewRoomVC.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
@class roomData;
@class TFJunYou_RoomObject;

@interface TFJunYou_NewRoomVC : TFJunYou_admobViewController{
    UITextField* _desc;
    UILabel* _userName;
    UISwitch * _readSwitch;
    UISwitch * _publicSwitch;
    UISwitch * _secretSwitch;
    UILabel* _size;
    TFJunYou_RoomObject *_chatRoom;
    roomData* _room;
}

@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;
@property (nonatomic,strong) NSString* userNickname;
@property (nonatomic,strong) UITextField* roomName;
@property (nonatomic, assign) BOOL isAddressBook;
@property (nonatomic, strong) NSMutableArray *addressBookArr;

@end
