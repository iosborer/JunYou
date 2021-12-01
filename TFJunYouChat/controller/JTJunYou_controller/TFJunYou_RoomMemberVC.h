//
//  TFJunYou_RoomMemberVC.h
//  TFJunYouChat
//
//  Created by flyeagleTang on 14-6-10.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TFJunYou_admobViewController.h"
@class roomData;
@class TFJunYou_RoomObject;

@protocol TFJunYou_RoomMemberVCDelegate <NSObject>

- (void) setNickName:(NSString *)nickName;
- (void) needVerify:(TFJunYou_MessageObject *)msg;

@end

@interface TFJunYou_RoomMemberVC : TFJunYou_admobViewController<LXActionSheetDelegate>{
    TFJunYou_Label* _desc;
    TFJunYou_Label* _userName;
    TFJunYou_Label* _roomName;
    UILabel* _memberCount;
    UILabel* _creater;
    UILabel* _size;
    NSMutableArray* _deleteArr;
    NSMutableArray* _images;
    NSMutableArray* _names;
    BOOL _delMode;
    TFJunYou_RoomObject *_chatRoom;
    int _h;
    BOOL _isAdmin;
    BOOL _allowEdit;
    UILabel* _note;
    UILabel* _userNum;
    UIView* _heads;
    int _delete;
    int _disable;
    BOOL _disableMode;
    BOOL _unfoldMode;
    TFJunYou_UserObject* _user;
    TFJunYou_ImageView* _blackBtn;
    int _modifyType;
    NSString* _content;
    NSString* _toUserId;
    NSString* _toUserName;
    UISwitch * _readSwitch;
    UISwitch *_messageFreeSwitch;
    UISwitch *_allNotTalkSwitch;
    UISwitch *_topSwitch;
    UISwitch *_notMsgSwitch;
    UILabel* _roomNum;
}

@property (nonatomic, assign) NSString *roomId;

@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;
@property (nonatomic,strong) roomData* room;
@property (nonatomic,strong) TFJunYou_ImageView * iv;
@property (nonatomic, weak) id<TFJunYou_RoomMemberVCDelegate>delegate;
@property (nonatomic, assign) int rowIndex;

//@property (nonatomic,strong) NSString* userNickname;

@end
