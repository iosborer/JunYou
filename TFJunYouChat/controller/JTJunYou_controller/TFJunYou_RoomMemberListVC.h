//
//  TFJunYou_RoomMemberListVC.h
//  TFJunYouChat
//
//  Created by p on 2018/7/3.
//  Copyright © 2018年 Reese. All rights reserved.
//

#import "TFJunYou_TableViewController.h"
#import "TFJunYou_RoomObject.h"

typedef enum : NSUInteger {
    Type_Default = 1,
    Type_NotTalk,
    Type_DelMember,
    Type_AddNotes,
} RoomMemberListType;

@class TFJunYou_InputValueVC;
@class TFJunYou_RoomMemberListVC;

@protocol TFJunYou_RoomMemberListVCDelegate <NSObject>

- (void) roomMemberList:(TFJunYou_RoomMemberListVC *)vc delMember:(memberData *)member;

- (void)roomMemberList:(TFJunYou_RoomMemberListVC *)selfVC addNotesVC:(TFJunYou_InputValueVC *)vc;

@end

@interface TFJunYou_RoomMemberListVC : TFJunYou_TableViewController


@property (nonatomic,strong) roomData* room;

@property (nonatomic, assign) RoomMemberListType type;
@property (nonatomic,strong) TFJunYou_RoomObject* chatRoom;

@property (nonatomic, weak) id<TFJunYou_RoomMemberListVCDelegate>delegate;

@end
