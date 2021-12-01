//
//  TFJunYou_SelectFriendsVC.h
//  TFJunYouChat
//
//  Created by p on 2018/7/2.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import <UIKit/UIKit.h>
@class menuImageView;
@class TFJunYou_RoomObject;

typedef NS_OPTIONS(NSInteger, TFJunYou_SelectFriendType) {
    TFJunYou_SelectFriendTypeGroupAT    = 1,
    TFJunYou_SelectFriendTypeSpecifyAdmin,
    TFJunYou_SelectFriendTypeSelMembers,
    TFJunYou_SelectFriendTypeSelFriends,
    TFJunYou_SelectFriendTypeCustomArray,
    TFJunYou_SelectFriendTypeDisAble,
};

@interface TFJunYou_SelectFriendsVC: TFJunYou_TableViewController{
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
@property (nonatomic, assign) SEL        didSelect;
@property (nonatomic,strong) NSMutableSet* set;
@property (nonatomic,strong) NSMutableArray* array;
//@property (nonatomic,strong) memberData* member;
@property (nonatomic,strong) NSSet * existSet;
@property (nonatomic,strong) NSSet * disableSet;
@property (nonatomic,assign) TFJunYou_SelectFriendType type;
@property (nonatomic, assign) BOOL isShowMySelf;

@property (nonatomic, assign) BOOL isForRoom;
@property (nonatomic, strong) TFJunYou_UserObject *forRoomUser;
@property (nonatomic, strong) NSMutableArray *userIds;
@property (nonatomic, strong) NSMutableArray *userNames;

@property (nonatomic, strong) UITextField *seekTextField;
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) NSMutableArray *addressBookArr;

@property (nonatomic, assign) BOOL isShowAlert;
@property (nonatomic, assign) SEL alertAction;

@property (nonatomic, assign) BOOL isAddWindow; // 是否是添加到window上

@property (nonatomic, assign) int maxSize;  // 最多可选择

@end
