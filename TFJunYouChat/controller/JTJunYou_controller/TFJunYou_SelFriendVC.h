//
//  TFJunYou_SelFriendVC.h
//
//  Created by lifengye on 2020/09/03.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;
@class TFJunYou_RoomObject;

typedef NS_OPTIONS(NSInteger, TFJunYou_SelUserType) {
    TFJunYou_SelUserTypeGroupAT    = 1,
    TFJunYou_SelUserTypeSpecifyAdmin,
    TFJunYou_SelUserTypeSelMembers,
    TFJunYou_SelUserTypeSelFriends,
    TFJunYou_SelUserTypeCustomArray,
    TFJunYou_SelUserTypeDisAble,
    TFJunYou_SelUserTypeRoomTransfer,
    TFJunYou_SelUserTypeRoomInvisibleMan,  //设置隐身人
    TFJunYou_SelUserTypeRoomMonitorPeople, // 设置监控人
};

@interface TFJunYou_SelFriendVC: TFJunYou_TableViewController{
    NSMutableArray* _array;
    int _refreshCount;
    menuImageView* _tb;
    UIView* _topView;
    int _selMenu;
    
}
@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;
@property (nonatomic,strong) roomData* room;
@property (assign) BOOL isNewRoom;
@property (nonatomic, weak) NSObject* delegate;
@property (nonatomic, assign) SEL		didSelect;
@property (nonatomic,strong) NSMutableSet* set;
@property (nonatomic,strong) NSMutableArray* array;
//@property (nonatomic,strong) memberData* member;
@property (nonatomic,strong) NSSet * existSet;
@property (nonatomic,strong) NSSet * disableSet;
@property (nonatomic,assign) TFJunYou_SelUserType type;
@property (nonatomic, assign) BOOL isShowMySelf;

@property (nonatomic, assign) BOOL isForRoom;
@property (nonatomic, strong) TFJunYou_UserObject *forRoomUser;
@property (nonatomic, strong) NSMutableArray *userIds;
@property (nonatomic, strong) NSMutableArray *userNames;

@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, assign) SEL alertAction;
@end
